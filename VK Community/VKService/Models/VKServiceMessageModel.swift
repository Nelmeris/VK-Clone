//
//  VKServiceMessageModel.swift
//  VK Community
//
//  Created by Артем on 31.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import SwiftyJSON
import RealmSwift

class VKMessageResponseModel: VKBaseModel {
    
    var count = 0
    var items: [VKMessageModel] = []
    var in_read = 0
    var out_read = 0
    
    required convenience init(json: JSON) {
        self.init()
        
        count = json["count"].intValue
        items = json["items"].map({ VKMessageModel(json: $0.1) })
        in_read = json["in_read"].intValue
        out_read = json["out_read"].intValue
    }
    
}

class VKMessageModel: DataBaseModel {
    
    @objc dynamic var id = 0
    @objc dynamic var date = 0
    @objc dynamic var out = 0
    @objc dynamic var user_id = 0
    @objc dynamic var read_state = 0
    @objc dynamic var title = ""
    @objc dynamic var body = ""
    @objc dynamic var chat_id = 0
    
    @objc dynamic var from_id = 0
    
    var chat_active = List<Int>()
    
    @objc dynamic var photo_100 = ""
    
    required convenience init(json: JSON) {
        self.init()
        
        id = json["id"].intValue
        date = json["date"].intValue
        out = json["out"].intValue
        user_id = json["user_id"].intValue
        read_state = json["read_state"].intValue
        title = json["title"].stringValue
        body = json["body"].stringValue
        chat_id = json["chat_id"].intValue
        
        photo_100 = json["photo_100"].stringValue
        
        from_id = json["from_id"].intValue
        
        if let intArray = json["chat_active"].arrayObject as? [Int] {
            chat_active.append(objectsIn: intArray)
        }
    }
    
    convenience init(id: Int, text: String, from_id: Int, date: Int) {
        self.init()
        
        self.id = id
        body = text
        self.from_id = from_id
        self.date = date
    }
    
    override func isEqual(_ object: DataBaseModel) -> Bool {
        let object = object as! VKMessageModel
        return (id == object.id) &&
            (date == object.date) &&
            (user_id == object.user_id) &&
            (from_id == object.from_id) &&
            (title == object.title) &&
            (body == object.body)
    }
    
}
