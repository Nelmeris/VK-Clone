//
//  Service.swift
//  VKService
//
//  Created by Артем on 09.05.2018.
//  Copyright © 2018 Nelmeris. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Keychain
import RealmSwift

let Scheme = "https"
let Host = "api.vk.com/method/"

// Получение нового токена
func TokenReceiving(_ sender: UIViewController) {
    sender.present(UIStoryboard(name: "VKViews", bundle: Bundle(for: Authorization.self)).instantiateViewController(withIdentifier: "Authorization"), animated: true, completion: nil)
}

// Проверка существования токена
func TokenIsExist() -> Bool {
    return Keychain.load("token") != nil
}

// Проверка токена на действительность
func TokenIsValid(_ sender: UIViewController, _ url: String, _ parameters: [String: String]) {
    Alamofire.request(url, parameters: parameters).responseData { response in
        guard let json = GetJSONResponse(response), json["error"]["error_code"].int != nil else { return }
        
        let error_msg = json["error"]["error_msg"].string!
        
        if error_msg.range(of: "token") != nil {
            TokenReceiving(sender)
        }
        
        print("REQUEST ERROR! " + error_msg)
    }
}

// Создание URL запроса
func RequestURL(_ sender: UIViewController, _ method: String, _ version: String, _ parameters: [String : String] = ["" : ""]) -> (url: String, parameters: [String: String])? {
    guard TokenIsExist() else {
        TokenReceiving(sender)
        return nil
    }
    
    let requestURL = Scheme + "://" + Host + method
    
    var requestParameters = parameters
    requestParameters["access_token"] = Keychain.load("token")
    requestParameters["v"] = version
    
    TokenIsValid(sender, requestURL, requestParameters)
    
    return (requestURL, requestParameters)
}

// Преобразование Data в JSON
func GetJSONResponse(_ response: DataResponse<Data>) -> JSON? {
    guard let data = response.value else { return nil }
    
    return try! JSON(data: data)
}

// Выполнение запроса
public func VKRequest<Response: Types>(sender: UIViewController, version: Versions = .v5_74, method: Methods, parameters: [String : String] = ["" : ""], completion: @escaping([Response]) -> Void = {_ in}) {
    guard let url = VKService.RequestURL(sender, method.rawValue, version.rawValue, parameters) else { return }
    
    Alamofire.request(url.url, parameters: url.parameters).responseData { response in
        guard let json = VKService.GetJSONResponse(response) else { return }
        
        completion(json["response"]["items"].map { Response(json: $0.1) })
    }
}

// Родитель всех типов запровос
open class Types: Object {
    required convenience public init(json: JSON) {
        self.init()
    }
}
