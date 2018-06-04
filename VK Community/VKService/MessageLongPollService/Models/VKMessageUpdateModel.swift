//
//  VKMessageUpdateModel.swift
//  VK Community
//
//  Created by Артем on 03.06.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import SwiftyJSON
import RealmSwift

class VKMessageUpdatesModel: VKBaseModel {
    
    var ts = 0
    var pts = 0
    var updates: [Update] = []
    
    class Update {
        
        var code = 0
        var update: VKBaseMessageUpdateModel! = nil
        
        required convenience init(json: JSON) {
            self.init()
            
            code = json[0].intValue
            
            switch code {
            case 4:
                update = VKMessageUpdateNewMessageModel(json)
                
            case 6,7:
                update = VKMessageUpdateReadMessagesModel(json)
                
            case 8,9:
                update = VKMessageUpdateOnlineStatusChangedModel(json)
                
            default: break
            }
        }
        
    }
    
    required convenience init(_ json: JSON) {
        self.init()
        
        ts = json["ts"].intValue
        pts = json["pts"].intValue
        updates = json["updates"].map({ Update(json: $0.1) })
    }
    
}

class VKBaseMessageUpdateModel {
    
    required convenience init(_ json: JSON) {
        self.init()
    }
    
}
