//
//  VKMessageUpdateFlagsModel.swift
//  VK Community
//
//  Created by Артем on 05.06.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import SwiftyJSON

class VKMessageUpdateFlagsModel: VKBaseMessageUpdateModel {
    
    var isOut = false
    
    required convenience init(_ json: JSON) {
        self.init()
    }
    
    required convenience init(_ flags: Int) {
        self.init()
        
        isOut = flags & 2 == 2
    }
    
}
