//
//  VKMessageUpdateReadMessagesModel.swift
//  VK Community
//
//  Created by Артем on 03.06.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import SwiftyJSON

class VKUpdateReadMessages: VKBaseUpdateModel {
    
    var peer_id = 0
    var local_id = 0
    
    required convenience init(_ json: JSON) {
        self.init()
        
        peer_id = json[1].intValue
        local_id = json[2].intValue
    }
    
}
