//
//  VKMethodGroups.swift
//  VK Community
//
//  Created by Артем on 10.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

extension VKService.Methods {
    struct Groups {
        
        // Вывод списка ID групп пользователя
        static func Get(sender: UIViewController, completion: @escaping(VKService.Structs.IDs) -> Void) {
            
            guard let url = VKService.RequestURL(sender, "groups.get", .v5_74) else {
                return
            }
            
            Alamofire.request(url).responseData { response in
                
                let json = try? JSON(data: response.value!)
                
                let groups = VKService.Structs.IDs(json: json!["response"])
                
                completion(groups)
                
            }
        }
        
        // Вывод подробного списка групп пользователя
        static func Get(sender: UIViewController, parameters: [String: String], completion: @escaping(VKService.Structs.Groups) -> Void) {
            
            guard let url = VKService.RequestURL(sender, "groups.get", .v5_74, parameters) else {
                return
            }
            
            Alamofire.request(url).responseData { response in
                
                let json = try? JSON(data: response.value!)
                
                let groups = VKService.Structs.Groups(json: json!["response"])
                
                completion(groups)
                
            }
        }
        
        // Вывод списка ID участников конкретной группы
        static func GetMembers(sender: UIViewController, group_id: String, completion: @escaping(VKService.Structs.IDs) -> Void) {
            
            guard let url = VKService.RequestURL(sender, "groups.getMembers", .v5_74, ["group_id": group_id]) else {
                return
            }
            
            Alamofire.request(url).responseData { response in
                
                let json = try? JSON(data: response.value!)
                
                let groups = VKService.Structs.IDs(json: json!["response"])
                
                completion(groups)
                
            }
        }
    }
}
