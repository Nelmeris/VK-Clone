//
//  VKService.swift
//  VK Community
//
//  Created by Артем on 09.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit

class VKService {
    
    // Параметры запросов
    static let Scheme = "https"
    static let Host = "api.vk.com/method/"
    static let URL = "https://api.vk.com/method/"
    
    // Пустой список методов
    struct Methods {}
    
    // Создание URL запроса
    internal static func RequestURL(_ sender: UIViewController, _ method: String, _ parameters: [String: String]?, _ version: VKAPIVersions) -> String {
        
        // Проверка действительности токена
        guard TokenIsValid() else {
            // Запрос на получение нового токена
            sender.present(UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VKAuthorization"), animated: true, completion: nil)
            
            // Новая попытка
            return RequestURL(sender, method, parameters, version)
        }
        
        // Создание URL запроса
        var url = VKService.URL + method + "?v=\(version.rawValue)&access_token=\((UserDefaults.standard.value(forKey: "token") as! String?)!)"
        
        // Добавление параметров в URL
        if let parameters = parameters {
            for element in parameters {
                url += "&\(element.key)=\(element.value)"
            }
        }
        
        return url
    }
    
    // Проверка валидности токена пользователя
    static func TokenIsValid() -> Bool {
        return UserDefaults.standard.value(forKey: "token") != nil && (UserDefaults.standard.value(forKey: "tokenDate") as! NSDate).timeIntervalSinceNow < 0
    }
    
}
