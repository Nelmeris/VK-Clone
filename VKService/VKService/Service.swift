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
    let storyboard = UIStoryboard(name: "VKViews", bundle: Bundle(for: Authorization.self))
    let viewController = storyboard.instantiateViewController(withIdentifier: "Authorization")
    sender.present(viewController, animated: true, completion: nil)
}

// Проверка существования токена
func TokenIsExist() -> Bool {
    return Keychain.load("token") != nil
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
    
    return (requestURL, requestParameters)
}

enum RequestError: Error {
    case ResponseError(String)
    case URLError(String)
    case AccessTokenError(String)
}

// Преобразование Data в JSON
func GetJSONResponse(_ response: DataResponse<Data>) throws -> JSON {
    switch response.result {
    case .success(let value):
        let json = try! JSON(data: value)
        
        if let error = json["error"].dictionary {
            let error_msg = error["error_msg"]!.stringValue
            if json["error_msg"].stringValue.range(of: "token") != nil {
                throw RequestError.AccessTokenError(error_msg)
            } else {
                throw RequestError.URLError(error_msg)
            }
        }
        
        return json["response"]
        
    case .failure(let error):
        throw RequestError.ResponseError(error.localizedDescription)
    }
}

// Выполнение запроса
public func VKRequest<Response: Types>(sender: UIViewController, version: Versions = .v5_74, method: Methods, parameters: [String : String] = ["" : ""], completion: @escaping([Response]) -> Void = {_ in}) {
    guard let url = RequestURL(sender, method.rawValue, version.rawValue, parameters) else { return }
    
    Alamofire.request(url.url, parameters: url.parameters).responseData { response in
        do {
            let json = try GetJSONResponse(response)
            
            completion(json["items"].map { Response(json: $0.1) })
            
        } catch RequestError.ResponseError(let error_msg) {
            print("REQUEST ERROR! " + error_msg)
        } catch RequestError.URLError(let error_msg) {
            print("REQUEST ERROR! " + error_msg)
        } catch RequestError.AccessTokenError(let error_msg) {
            TokenReceiving(sender)
            print("REQUEST ERROR! " + error_msg)
        } catch {}
    }
}

// Родитель всех типов запросов
open class Types: Object {
    required convenience public init(json: JSON) {
        self.init()
    }
}
