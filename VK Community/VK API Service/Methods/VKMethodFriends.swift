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
        
        // Вывод подробного списка друзей пользователя
        static func get(sender: UIViewController, version: VKService.Versions, parameters: [String: String], completion: @escaping([User]) -> Void) {
            guard let url = VKService.RequestURL(sender, "friends.get", version, parameters) else { return }
            
            Alamofire.request(url.url, parameters: url.parameters).responseData { response in
                guard let json = VKService.GetJSONResponse(response) else { return }
                
                completion(json["items"].map { User(json: $0.1) })
            }
        }
        
    }
}
