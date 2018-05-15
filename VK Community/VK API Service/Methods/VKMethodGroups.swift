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
        
        // Вывод подробного списка групп пользователя
        static func get(sender: UIViewController, version: VKService.Versions, parameters: [String: String], completion: @escaping([Group]) -> Void) {
            guard let url = VKService.RequestURL(sender, "groups.get", version, parameters) else { return }
            
            Alamofire.request(url.url, parameters: url.parameters).responseData { response in
                guard let json = VKService.GetJSONResponse(response) else { return }
                
                completion(json["items"].map { Group(json: $0.1) })
            }
        }
        
        // Вывод результата поиска групп по имени
        static func search(sender: UIViewController, version: VKService.Versions, q: String, parameters: [String: String] = ["":""], completion: @escaping([Group]) -> Void) {
            var requestParameters = parameters
            requestParameters["q"] = q
            
            guard let url = VKService.RequestURL(sender, "groups.search", version, requestParameters) else { return }
            
            Alamofire.request(url.url, parameters: url.parameters).responseData { response in
                guard let json = VKService.GetJSONResponse(response) else { return }
                
                completion(json["items"].map { Group(json: $0.1) })
            }
        }
        
    }
}
