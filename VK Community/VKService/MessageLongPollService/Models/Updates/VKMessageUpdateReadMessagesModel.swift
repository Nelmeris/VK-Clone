//
//  VKMessageUpdateReadMessagesModel.swift
//  VK Community
//
//  Created by Артем on 03.06.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import SwiftyJSON

class VKMessageUpdateReadMessagesModel: VKBaseMessageUpdateModel {
    
    var peerId = 0
    var localId = 0
    
    required convenience init(_ json: JSON) {
        self.init()
        
        peerId = json[1].intValue
        localId = json[2].intValue
    }
    
}
