//
//  User.swift
//  VKService
//
//  Created by Артем on 09.05.2018.
//  Copyright © 2018 Nelmeris. All rights reserved.
//

import SwiftyJSON
import RealmSwift

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
    
    public var photos = List<VKPhoto>()
    
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
    
    override open func isEqual (_ object: DataBaseModel) -> Bool {
        let object = object as! VKUser
        return (self.id == object.id) &&
            (self.first_name == object.first_name) &&
            (self.last_name == object.last_name) &&
            (self.photo_50 == object.photo_50) &&
            (self.photo_100 == object.photo_100) &&
            (self.photo_200_orig == object.photo_200_orig) &&
            (self.online == object.online) &&
            (self.online_mobile == object.online_mobile)
    }
    
}
