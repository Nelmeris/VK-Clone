//
//  VKServiceMessageModel.swift
//  VK Community
//
//  Created by Артем on 31.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import SwiftyJSON
import RealmSwift

class VKMessageModel: DataBaseModel {
    
    @objc dynamic var id = 0
    @objc dynamic var date = 0
    @objc dynamic var out = 0
    @objc dynamic var user_id = 0
    @objc dynamic var real_state = 0
    @objc dynamic var title = ""
    @objc dynamic var body = ""
    @objc dynamic var random_id = 0
    @objc dynamic var chat_id = 0
    
    var chat_active = List<Int>()
    
    required convenience init(json: JSON) {
        self.init()
        
        id = json["id"].intValue
        date = json["date"].intValue
        out = json["out"].intValue
        user_id = json["user_id"].intValue
        real_state = json["real_state"].intValue
        title = json["title"].stringValue
        body = json["body"].stringValue
        random_id = json["random_id"].intValue
        chat_id = json["chat_id"].intValue
        
        if let intArray = json["chat_active"].arrayObject as? [Int] {
            chat_active.append(objectsIn: intArray)
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
