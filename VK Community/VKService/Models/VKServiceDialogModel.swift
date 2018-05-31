//
//  VKServiceDialogModel.swift
//  VK Community
//
//  Created by Артем on 31.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import SwiftyJSON

// Данные диалога
class VKDialogModel: DataBaseModel {
    
    @objc dynamic var unread = 0
    @objc dynamic var message: VKMessageModel! = nil
    @objc dynamic var in_read = 0
    @objc dynamic var out_read = 0
    
    required convenience init(json: JSON) {
        self.init()
        
        unread = json["unread"].intValue
        message = VKMessageModel(json: json["message"])
        in_read = json["in_read"].intValue
        out_read = json["out_read"].intValue
    }
    
}
