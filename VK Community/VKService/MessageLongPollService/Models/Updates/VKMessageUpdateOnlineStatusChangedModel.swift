//
//  VKMessageUpdateOnlineStatusChangedModel.swift
//  VK Community
//
//  Created by Артем on 04.06.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import SwiftyJSON

class VKMessageUpdateOnlineStatusChangedModel: VKBaseMessageUpdateModel {
    
    var userId = 0
    
    required convenience init(_ json: JSON) {
        self.init()
        
        userId = json[1].intValue
    }
    
}
