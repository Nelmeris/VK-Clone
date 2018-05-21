//
//  User.swift
//  VKService
//
//  Created by Артем on 09.05.2018.
//  Copyright © 2018 Nelmeris. All rights reserved.
//

import SwiftyJSON

// Данные пользователя
open class VKUser: DataBaseModel {
    
    @objc dynamic public var id = 0
    @objc dynamic public var first_name = ""
    @objc dynamic public var last_name = ""
    @objc dynamic public var photo_50 = ""
    @objc dynamic public var photo_100 = ""
    @objc dynamic public var photo_200_orig = ""
    @objc dynamic public var online = 0
    @objc dynamic public var online_mobile = 0
    
    public convenience required init(json: JSON) {
        self.init()
        
        self.id = json["id"].intValue
        self.first_name = json["first_name"].stringValue
        self.last_name = json["last_name"].stringValue
        self.photo_50 = json["photo_50"].stringValue
        self.photo_100 = json["photo_100"].stringValue
        self.photo_200_orig = json["photo_200_orig"].stringValue
        self.online = json["online"].intValue
        self.online_mobile = json["online_mobile"].intValue
    }
    
    override open static func primaryKey() -> String? {
        return "id"
    }
    
}
