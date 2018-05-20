//
//  Group.swift
//  VKService
//
//  Created by Артем on 10.05.2018.
//  Copyright © 2018 Nelmeris. All rights reserved.
//

import SwiftyJSON

// Данные группы
open class VKGroup: DataBaseModel {
    
    @objc dynamic public var id = 0
    @objc dynamic public var name = ""
    @objc dynamic public var photo_100 = ""
    @objc dynamic public var members_count = 0
    
    public required convenience init(json: JSON) {
        self.init()
        
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.photo_100 = json["photo_100"].stringValue
        self.members_count = json["members_count"].intValue
    }
    
}
