//
//  GetData.swift
//  VK Community
//
//  Created by Артем on 08.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import Alamofire

open class VK_Service {
    static let Scheme = "https"
    static let Host = "api.vk.com/method/"
    static let Version = "5.52"
    
    static func Methods(sender: UIViewController, method: String, token: String, options: [String: String]? = nil) {
        
        guard TokenIsValid() else {
            // Запрос на получение нового токена
            sender.present(UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VKAuthorization"), animated: true, completion: nil)
            
            // Новая попытка
            Methods (sender: sender, method: method, token: token, options: options)
            return
        }
        
        var url = "\(Scheme)://\(Host)\(method)?v=\(Version)&access_token=\(token)"
        if options != nil {
            for element in options! {
                url += "&\(element.key)=\(element.value)"
            }
        }
        Alamofire.request(url).responseJSON { response in
            print(response.value)
        }
    }
    
    // Проверка валидности токена пользователя
    static func TokenIsValid() -> Bool {
        return UserDefaults.standard.value(forKey: "token") != nil && (UserDefaults.standard.value(forKey: "tokenDate") as! NSDate).timeIntervalSinceNow < 0
    }
}
