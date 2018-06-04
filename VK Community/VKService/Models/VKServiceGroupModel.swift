//
//  VKServiceGroupModel.swift
//  VK Community
//
//  Created by Артем on 10.05.2018.
//  Copyright © 2018 Nelmeris. All rights reserved.
//

import SwiftyJSON

class VKGroupsResponseModel: VKBaseModel {
    
    var response: [VKGroupModel] = []
    
    required convenience init(json: JSON) {
        self.init()
        
        response = json.map({ VKGroupModel(json: $0.1) })
    }
    
}

class VKGroupModel: RealmModel {
    
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var photo_100 = ""
    @objc dynamic var members_count = 0
    
    required convenience init(json: JSON) {
        self.init()
        
        id = json["id"].intValue
        name = json["name"].stringValue
        photo_100 = json["photo_100"].stringValue
        members_count = json["members_count"].intValue
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override func isEqual (_ object: RealmModel) -> Bool {
        let object = object as! VKGroupModel
        return (id == object.id) &&
            (name == object.name) &&
            (photo_100 == object.photo_100) &&
            (members_count == object.members_count)
    }
    
}
