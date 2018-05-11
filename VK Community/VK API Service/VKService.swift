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

class VKService {
    
    static let Scheme = "https"
    static let Host = "api.vk.com/method/"
    
    struct Requests {}
    
    // Базовый безвозвратный запрос
    static func Request(sender: UIViewController, method: NonReturnMethods, version: Versions, parameters: [String: String] = ["" : ""]) {
        guard let url = VKService.RequestURL(sender, method.rawValue, version, parameters) else { return }
        
        _ = Alamofire.request(url.url + method.rawValue, parameters: url.parameters).response
    }
    
    struct Structs {}
    
    // Создание URL запроса
    internal static func RequestURL(_ sender: UIViewController, _ method: String, _ version: Versions, _ parameters: [String : String] = ["" : ""]) -> (url: String, parameters: [String: String])? {
        
        guard TokenIsExist() else {
            TokenReceiving(sender)
            return nil
        }
        
        let requestURL = Scheme + "://" + Host + method
        
        var requestParameters = parameters
        requestParameters["access_token"] = Keychain.load("token")
        requestParameters["v"] = version.rawValue
        
        TokenIsValid(sender, requestURL, requestParameters)
        
        return (requestURL, requestParameters)
    }
    
    // Проверка существования токена
    static func TokenIsExist() -> Bool {
        return Keychain.load("token") != nil
    }
    
    // Получение нового токена
    static func TokenReceiving(_ sender: UIViewController) {
        sender.present(UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VKAuthorization"), animated: true, completion: nil)
    }
    
    // Проверка токена на действительность
    static func TokenIsValid(_ sender: UIViewController, _ url: String, _ parameters: [String: String]) {
        
        Alamofire.request(url, parameters: parameters).responseData { response in
            guard let data = response.value else { return }
            
            let json = try! JSON(data: data)
            
            let error_code = json["error"]["error_code"].int ?? nil
            
            guard error_code == nil else {
                let error_msg = json["error"]["error_msg"].string!
                
                if error_msg.range(of: "token") != nil {
                    TokenReceiving(sender)
                }
                
                print("REQUEST ERROR! " + error_msg)
                
                return
            }
        }
        
    }
    
    static func GetJSON(_ response: DataResponse<Data>) -> JSON? {
        guard let data = response.value else { return nil }
        
        return try! JSON(data: data)
    }
    
}
