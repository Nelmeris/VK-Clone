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
    static let URL = "https://api.vk.com/method/"
    
    struct Methods {}
    
    struct Structs {}
    
    // Создание URL запроса
    internal static func RequestURL(_ sender: UIViewController, _ method: String, _ version: Versions, _ parameters: [String: String]? = nil) -> (String, [String: String])? {
        
        guard TokenIsExist() else {
            // Запрос на получение нового токена
            sender.present(UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VKAuthorization"), animated: true, completion: nil)
            
            return nil
        }
        
        var p = ["":""]
        
        if parameters != nil {
            p = parameters!
        }
        
        p["access_token"] = Keychain.load("token")
        p["v"] = version.rawValue
        
        // Проверка наличия и обработка ошибок
        Alamofire.request(URL + method, parameters: p).responseData { response in
            let json = try? JSON(data: response.value!)
            
            let error_msg = json?["error"]["error_msg"].stringValue ?? nil
            let error_code = json?["error"]["error_code"].int ?? nil
            
            guard error_code == nil else {
                switch error_code {
                case 5:
                    sender.present(UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VKAuthorization"), animated: true, completion: nil)
                    return
                default:
                    print(error_msg!)
                    return
                }
            }
        }
        
        return (URL + method, p)
    }
    
    // Проверка существования токена пользователя
    static func TokenIsExist() -> Bool {
        return UserDefaults.standard.value(forKey: "token") != nil
    }
    
    static func Method(sender: UIViewController, method: NonReturnMethods, version: Versions, parameters: [String: String]) {
        guard let url = VKService.RequestURL(sender, method.rawValue, version, parameters) else {
            return
        }
        
        Alamofire.request(url.0 + method.rawValue, parameters: url.1).response
    }
    
}
