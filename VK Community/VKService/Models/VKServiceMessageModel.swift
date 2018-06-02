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

class VKMessageLongPollServer: DataBaseModel {
    
    @objc dynamic var key = ""
    @objc dynamic var server = ""
    @objc dynamic var ts = 0
    @objc dynamic var pts = 0
    
    required convenience init(json: JSON) {
        self.init()
        
        key = json["key"].stringValue
        server = json["server"].stringValue
        ts = json["ts"].intValue
        pts = json["pts"].intValue
    }
    
}

class VKUpdateModel: VKBaseModel {
    
    var ts = 0
    var pts = 0
    var updates: [Update] = []
    
    class Update {
        
        var code = 0
        var update: UpdateModel = UpdateModel(JSON())
        
        class UpdateModel {
            required convenience init(_ json: JSON) {
                self.init()
            }
        }
        
        class NewMessage: UpdateModel {
            
            var message_id = 0
            var flags = 0
            var peer_id = 0
            var timestamp = 0
            var text = ""
            
            required convenience init(_ json: JSON) {
                self.init()
                
                message_id = json[1].intValue
                flags = json[2].intValue
                peer_id = json[3].intValue
                timestamp = json[4].intValue
                text = json[5].stringValue
            }
            
        }
        
        class ReadMessages: UpdateModel {
            var peer_id = 0
            var local_id = 0
            
            required convenience init(_ json: JSON) {
                self.init()
                
                peer_id = json[1].intValue
                local_id = json[2].intValue
            }
        }
        
        required convenience init(json: JSON) {
            self.init()
            
            print(json)
            
            code = json[0].intValue
            
            switch code {
            case 4:
                update = NewMessage(json)
            case 6,7:
                update = ReadMessages(json)
            default:
                update = UpdateModel(json)
            }
        }
        
    }
    
    convenience required init(json: JSON) {
        self.init()
        
        ts = json["ts"].intValue
        pts = json["pts"].intValue
        updates = json["updates"].map({ Update(json: $0.1) })
    }
    
}

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
    
    @objc dynamic var from_id = 0
    
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
        
        from_id = json["from_id"].intValue
        
        if let intArray = json["chat_active"].arrayObject as? [Int] {
            chat_active.append(objectsIn: intArray)
        }
    }
    
    convenience init(id: Int, text: String, from_id: Int) {
        self.init()
        
        self.id = id
        body = text
        self.from_id = from_id
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
