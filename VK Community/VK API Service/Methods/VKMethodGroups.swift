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
                
                let friends = VKService.Structs.IDs(json: json!["response"])
                
                completion(friends)
                
            }
        }
        
        // Вывод списка ID участников конкретной группы
        static func GetMembers(sender: UIViewController, group_id: String, completion: @escaping(VKService.Structs.IDs) -> Void) {
            
            guard let url = VKService.RequestURL(sender, "groups.getMembers", .v5_74, ["group_id": group_id]) else {
                return
            }
            
            Alamofire.request(url).responseData { response in
                
                let json = try? JSON(data: response.value!)
                
                let friends = VKService.Structs.IDs(json: json!["response"])
                
                completion(friends)
                
            }
        }
    }
}
