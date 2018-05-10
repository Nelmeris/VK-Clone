//
//  VKMethodFriends.swift
//  VK Community
//
//  Created by Артем on 09.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import Alamofire
import UIKit
import SwiftyJSON

extension VKService.Methods {
    struct Friends {
        
        // Вывод списка ID друзей пользователя
        static func Get(sender: UIViewController, completion: @escaping(VKService.Structs.IDs) -> Void) {
            
            guard let url = VKService.RequestURL(sender, "friends.get", .v5_74) else {
                return
            }
            
            Alamofire.request(url).responseData { response in
                
                let json = try? JSON(data: response.value!)
                
                let friends = VKService.Structs.IDs(json: json!["response"])
                
                completion(friends)
                
            }
        }
        
        // Вывод подробного списка друзей пользователя
        static func Get(sender: UIViewController, parameters: [String: String], completion: @escaping(VKService.Structs.Friends) -> Void) {
            
            guard let url = VKService.RequestURL(sender, "friends.get", .v5_74, parameters) else {
                return
            }
            
            Alamofire.request(url).responseData { response in
                
                let json = try? JSON(data: response.value!)
                
                let friends = VKService.Structs.Friends(json: json!["response"])
                
                completion(friends)
                
            }
        }
    }
}
