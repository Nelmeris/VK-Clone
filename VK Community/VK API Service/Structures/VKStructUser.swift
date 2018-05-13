//
//  VKStructFriend.swift
//  VK Community
//
//  Created by Артем on 09.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import SwiftyJSON

extension VKService.Structs {
    
    // Список пользователей
    class Users: VKService.Structs {
        var count: Int
        var items: [User]
        
        override init(json: JSON) {
            count = json["count"].intValue
            items = json["items"].map { User(json: $0.1)}
            super.init(json: json)
        }
    }
    
    // Данные пользователя
    class User: VKService.Structs {
        var id: Int
        var first_name = ""
        var last_name = ""
        var photo_50 = ""
        var photo_100 = ""
        var photo_200_orig = ""
        var online = 0
        var online_mobile = 0
        
        override init(json: JSON) {
            id = json["id"].intValue
            first_name = json["first_name"].stringValue
            last_name = json["last_name"].stringValue
            photo_50 = json["photo_50"].stringValue
            photo_100 = json["photo_100"].stringValue
            photo_200_orig = json["photo_200_orig"].stringValue
            online = json["online"].intValue
            online_mobile = json["online_mobile"].intValue
            super.init(json: json)
        }
    }
}
