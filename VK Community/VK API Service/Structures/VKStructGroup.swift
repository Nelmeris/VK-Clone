//
//  VKStructGroup.swift
//  VK Community
//
//  Created by Артем on 10.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import SwiftyJSON

extension VKService.Structs {
    
    // Список групп
    class Groups {
        var count: Int
        var items: [Group]
        
        init(json: JSON) {
            count = json["count"].intValue
            items = json["items"].map { Group(json: $0.1)}
        }
    }
    
    // Данные группы
    class Group {
        var id: Int
        var name = ""
        var photo_100 = ""
        var members_count: Int
        
        init(json: JSON) {
            id = json["id"].intValue
            name = json["name"].stringValue
            photo_100 = json["photo_100"].stringValue
            members_count = json["members_count"].intValue
        }
    }
}
