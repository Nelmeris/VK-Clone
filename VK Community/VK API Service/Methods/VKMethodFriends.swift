//
//  VKMethodFriends.swift
//  VK Community
//
//  Created by Артем on 09.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

extension VKService.Requests {
    struct friends {
        
        // Вывод списка ID друзей пользователя
        static func get(sender: UIViewController, version: VKService.Versions, completion: @escaping(VKService.Structs.IDs) -> Void) {
            
            guard let url = VKService.RequestURL(sender, "friends.get", version) else { return }
            
            Alamofire.request(url.url, parameters: url.parameters).responseData { response in
                
                guard let json = VKService.GetJSON(response) else { return }
                
                let friends = VKService.Structs.IDs(json: json["response"])
                
                completion(friends)
                
            }
        }
        
        // Вывод подробного списка друзей пользователя
        static func get(sender: UIViewController, version: VKService.Versions, parameters: [String: String], completion: @escaping(VKService.Structs.Friends) -> Void) {
            
            guard let url = VKService.RequestURL(sender, "friends.get", version, parameters) else { return }
            
            Alamofire.request(url.url, parameters: url.parameters).responseData { response in
                
                guard let json = VKService.GetJSON(response) else { return }
                
                let friends = VKService.Structs.Friends(json: json["response"])
                
                completion(friends)
                
            }
        }
        
    }
}
