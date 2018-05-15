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
        @objc dynamic var count: Int = 0
        @objc dynamic var items: [User] = []
        
        convenience init(json: JSON) {
            self.init(json: json)
            self.count = json["count"].intValue
            self.items = json["items"].map { User(json: $0.1)}
        }
    }
    
    // Данные пользователя
    class User: VKService.Structs {
        @objc dynamic var id = 0
        @objc dynamic var first_name = ""
        @objc dynamic var last_name = ""
        @objc dynamic var photo_50 = ""
        @objc dynamic var photo_100 = ""
        @objc dynamic var photo_200_orig = ""
        @objc dynamic var online = 0
        @objc dynamic var online_mobile = 0
        
        convenience init(json: JSON) {
            self.init(json: json)
            self.id = json["id"].intValue
            self.first_name = json["first_name"].stringValue
            self.last_name = json["last_name"].stringValue
            self.photo_50 = json["photo_50"].stringValue
            self.photo_100 = json["photo_100"].stringValue
            self.photo_200_orig = json["photo_200_orig"].stringValue
            self.online = json["online"].intValue
            self.online_mobile = json["online_mobile"].intValue
        }
    }
}
