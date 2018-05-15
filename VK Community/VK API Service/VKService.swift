//
//  VKService.swift
//  VK Community
//
//  Created by Артем on 09.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Keychain
import RealmSwift

class VKService {
    
    internal static let Scheme = "https"
    internal static let Host = "api.vk.com/method/"
    
    // Получение нового токена
    internal static func TokenReceiving(_ sender: UIViewController) {
        sender.present(UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VKAuthorization"), animated: true, completion: nil)
    }
    
    // Проверка существования токена
    internal static func TokenIsExist() -> Bool {
        return Keychain.load("token") != nil
    }
    
    // Проверка токена на действительность
    internal static func TokenIsValid(_ sender: UIViewController, _ url: String, _ parameters: [String: String]) {
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
    internal static func RequestURL(_ sender: UIViewController, _ method: String, _ version: String, _ parameters: [String : String] = ["" : ""]) -> (url: String, parameters: [String: String])? {
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
    internal static func GetJSONResponse(_ response: DataResponse<Data>) -> JSON? {
        guard let data = response.value else { return nil }
        
        return try! JSON(data: data)["response"]
    }
    
    // Выполнение запроса
    static func Request<Response: Structures>(sender: UIViewController, version: Versions = .v5_74, method: Methods, parameters: [String : String] = ["" : ""], completion: @escaping([Response]) -> Void = {_ in}) {
        guard let url = VKService.RequestURL(sender, method.rawValue, version.rawValue, parameters) else { return }
        
        Alamofire.request(url.url, parameters: url.parameters).responseData { response in
            guard let json = VKService.GetJSONResponse(response) else { return }
            
            completion(json["items"].map { Response(json: $0.1) })
        }
    }
    
}

internal class Structures {
    required convenience init(json: JSON) {
        self.init()
    }
}
