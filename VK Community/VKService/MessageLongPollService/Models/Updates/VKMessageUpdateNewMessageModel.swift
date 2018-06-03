//
//  VKMessageUpdateNewMessageModel.swift
//  VK Community
//
//  Created by Артем on 03.06.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import SwiftyJSON

class VKUpdateNewMessage: VKBaseUpdateModel {
    
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
