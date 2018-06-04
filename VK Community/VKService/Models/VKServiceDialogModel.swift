//
//  VKServiceDialogModel.swift
//  VK Community
//
//  Created by Артем on 31.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import SwiftyJSON
import RealmSwift

class VKDialogModel: RealmModel {
    
    @objc dynamic var id = 0
    @objc dynamic var type = ""
    @objc dynamic var title = ""
    
    @objc dynamic var unread = 0
    @objc dynamic var message: VKMessageModel!
    
    var messages = List<VKMessageModel>()
    
    @objc dynamic var in_read = 0
    @objc dynamic var out_read = 0
    
    @objc dynamic var users_count = 0
    @objc dynamic var admin_id = 0
    @objc dynamic var photo_50 = ""
    @objc dynamic var photo_100 = ""
    @objc dynamic var photo_200 = ""
    
    @objc dynamic var online = 0
    @objc dynamic var online_mobile = 0
    
    required convenience init(json: JSON) {
        self.init()
        
        unread = json["unread"].intValue
        message = VKMessageModel(json: json["message"])
        in_read = json["in_read"].intValue
        out_read = json["out_read"].intValue
        
        title = json["message"]["title"].stringValue
        users_count = json["message"]["users_count"].intValue
        admin_id = json["message"]["admin_id"].intValue
        photo_50 = json["message"]["photo_50"].stringValue
        photo_100 = json["message"]["photo_100"].stringValue
        photo_200 = json["message"]["photo_200"].stringValue
        
        if message.chat_id != 0 {
            id = 2000000000 + message.chat_id
            type = "chat"
        } else {
            if message.user_id > 0 {
                id = message.user_id
                type = "profile"
            } else {
                id = -message.user_id
                type = "group"
            }
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override func isEqual (_ object: RealmModel) -> Bool {
        let object = object as! VKDialogModel
        return (self.id == object.id) &&
            (title == object.title) &&
            (type == object.type) &&
            (photo_100 == object.photo_100) &&
            (online == object.online) &&
            (online_mobile == object.online_mobile) &&
            (message.date == object.message.date) &&
            (message.body == object.message.body)
    }
    
}
