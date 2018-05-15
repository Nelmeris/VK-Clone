//
//  VKStructGroup.swift
//  VK Community
//
//  Created by Артем on 10.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import SwiftyJSON

// Данные группы
class Group: VKService.Structures {
    
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var photo_100 = ""
    @objc dynamic var members_count = 0
    
    convenience init(json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.photo_100 = json["photo_100"].stringValue
        self.members_count = json["members_count"].intValue
    }
    
}
