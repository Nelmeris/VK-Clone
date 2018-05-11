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

extension VKService.Requests {
    struct groups {
        
        // Вывод списка ID групп пользователя
        static func get(sender: UIViewController, version: VKService.Versions, completion: @escaping(VKService.Structs.IDs) -> Void) {
            
            guard let url = VKService.RequestURL(sender, "groups.get", version) else { return }
            
            Alamofire.request(url.url, parameters: url.parameters).responseData { response in
                
                guard let json = VKService.GetJSON(response) else { return }
                
                let groups = VKService.Structs.IDs(json: json["response"])
                
                completion(groups)
                
            }
        }
        
        // Вывод подробного списка групп пользователя
        static func get(sender: UIViewController, version: VKService.Versions, parameters: [String: String], completion: @escaping(VKService.Structs.Groups) -> Void) {
            
            guard let url = VKService.RequestURL(sender, "groups.get", version, parameters) else { return }
            
            Alamofire.request(url.url, parameters: url.parameters).responseData { response in
                
                guard let json = VKService.GetJSON(response) else { return }
                
                let groups = VKService.Structs.Groups(json: json["response"])
                
                completion(groups)
                
            }
        }
        
        // Вывод подробного списка групп пользователя
        static func search(sender: UIViewController, version: VKService.Versions, q: String, parameters: [String: String] = ["":""], completion: @escaping(VKService.Structs.Groups) -> Void) {
            
            var requestParameters = parameters
            requestParameters["q"] = q
            
            guard let url = VKService.RequestURL(sender, "groups.search", version, requestParameters) else { return }
            
            Alamofire.request(url.url, parameters: url.parameters).responseData { response in
                
                guard let json = VKService.GetJSON(response) else { return }
                
                let groups = VKService.Structs.Groups(json: json["response"])
                
                completion(groups)
                
            }
        }
        
    }
}
