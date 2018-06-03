//
//  VKMessageUpdateOnlineStatusChangedModel.swift
//  VK Community
//
//  Created by Артем on 04.06.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import SwiftyJSON

class VKUpdateOnlineStatusChanged: VKBaseUpdateModel {
    
    var user_id = 0
    
    required convenience init(_ json: JSON) {
        self.init()
        
        user_id = json[1].intValue
    }
    
}
