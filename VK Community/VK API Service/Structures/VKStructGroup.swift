//
//  VKStructGroup.swift
//  VK Community
//
//  Created by Артем on 10.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import SwiftyJSON

extension VKService.Structs {
    struct Group {
        var id: Int
        var name = ""
        var photo_100 = ""
        
        init(json: JSON) {
            id = json["id"].intValue
            name = json["name"].stringValue
            photo_100 = json["photo_100"].stringValue
        }
    }
}
