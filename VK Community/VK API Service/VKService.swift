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

class VKService {
    
    static let Scheme = "https"
    static let Host = "api.vk.com/method/"
    static let URL = "https://api.vk.com/method/"
    
    struct Methods {}
    
    struct Structs {}
    
    // Создание URL запроса
    internal static func RequestURL(_ sender: UIViewController, _ method: String, _ version: VKAPIVersions, _ parameters: [String: String]? = nil) -> String? {
        
        // Проверка действительности токена
        guard TokenIsExist() else {
            // Запрос на получение нового токена
            sender.present(UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VKAuthorization"), animated: true, completion: nil)
            
            return nil
        }
        
        var url = VKService.URL + method + "?v=\(version.rawValue)&access_token=\((UserDefaults.standard.value(forKey: "token") as! String?)!)"
        if let parameters = parameters {
            for element in parameters {
                url += "&\(element.key)=\(element.value)"
            }
        }
        
        return url
    }
    
    // Проверка валидности токена пользователя
    static func TokenIsExist() -> Bool {
        return UserDefaults.standard.value(forKey: "token") != nil
    }
    
}
