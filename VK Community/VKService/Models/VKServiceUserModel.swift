//
//  VKServiceUserModel.swift
//  VK Community
//
//  Created by Артем on 09.05.2018.
//  Copyright © 2018 Nelmeris. All rights reserved.
//

import SwiftyJSON
import RealmSwift

class VKUsersResponseModel: VKBaseModel {
    
    var response: [VKUserModel] = []
    
    required convenience init(json: JSON) {
        self.init()
        
        response = json.map({ VKUserModel(json: $0.1) })
    }
    
}

class VKUserModel: RealmModel {
    
    @objc dynamic var id = 0
    @objc dynamic var first_name = ""
    @objc dynamic var last_name = ""
    @objc dynamic var photo_50 = ""
    @objc dynamic var photo_100 = ""
    @objc dynamic var photo_200_orig = ""
    @objc dynamic var online = 0
    @objc dynamic var online_mobile = 0
    
    var photos = List<VKPhotoModel>()
    
    required convenience init(json: JSON) {
        self.init()
        
        id = json["id"].intValue
        first_name = json["first_name"].stringValue
        last_name = json["last_name"].stringValue
        photo_50 = json["photo_50"].stringValue
        photo_100 = json["photo_100"].stringValue
        photo_200_orig = json["photo_200_orig"].stringValue
        online = json["online"].intValue
        online_mobile = json["online_mobile"].intValue
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override func isEqual (_ object: RealmModel) -> Bool {
        let object = object as! VKUserModel
        return (id == object.id) &&
            (first_name == object.first_name) &&
            (last_name == object.last_name) &&
            (photo_50 == object.photo_50) &&
            (photo_100 == object.photo_100) &&
            (photo_200_orig == object.photo_200_orig) &&
            (online == object.online) &&
            (online_mobile == object.online_mobile)
    }
    
}
