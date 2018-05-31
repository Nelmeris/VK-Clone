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
class VKUserModel: DataBaseModel {
    
    @objc dynamic var id = 0
    @objc dynamic var first_name = ""
    @objc dynamic var last_name = ""
    @objc dynamic var photo_50 = ""
    @objc dynamic var photo_100 = ""
    @objc dynamic var photo_200_orig = ""
    @objc dynamic var online = 0
    @objc dynamic var online_mobile = 0
    
    var photos = List<VKPhotoModel>()
    
    convenience required init(json: JSON) {
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
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override func isEqual (_ object: DataBaseModel) -> Bool {
        let object = object as! VKUserModel
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
