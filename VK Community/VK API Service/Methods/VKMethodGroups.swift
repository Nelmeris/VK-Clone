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
    struct groups {
        
        // Вывод списка ID групп пользователя
        static func get(sender: UIViewController, completion: @escaping(VKService.Structs.IDs) -> Void) {
            
            guard let url = VKService.RequestURL(sender, "groups.get", .v5_74) else {
                return
            }
            
            Alamofire.request(url.0, parameters: url.1).responseData { response in
                
                let json = try? JSON(data: response.value!)
                
                let groups = VKService.Structs.IDs(json: json!["response"])
                
                completion(groups)
                
            }
        }
        
        // Вывод подробного списка групп пользователя
        static func get(sender: UIViewController, parameters: [String: String], completion: @escaping(VKService.Structs.Groups) -> Void) {
            
            guard let url = VKService.RequestURL(sender, "groups.get", .v5_74, parameters) else { return }
            
            Alamofire.request(url.0, parameters: url.1).responseData { response in
                
                let json = try? JSON(data: response.value!)
                
                let groups = VKService.Structs.Groups(json: json!["response"])
                
                completion(groups)
                
            }
        }
        
        // Вывод подробного списка групп пользователя
        static func search(sender: UIViewController, q: String, parameters: [String: String] = ["":""], completion: @escaping(VKService.Structs.Groups) -> Void) {
            var parameters = parameters
            parameters["q"] = q
            
            guard let url = VKService.RequestURL(sender, "groups.search", .v5_74, parameters) else { return }
            
            Alamofire.request(url.0, parameters: url.1).responseData { response in
                
                let json = try? JSON(data: response.value!)
                
                let groups = VKService.Structs.Groups(json: json!["response"])
                
                completion(groups)
                
            }
        }
        
    }
}
