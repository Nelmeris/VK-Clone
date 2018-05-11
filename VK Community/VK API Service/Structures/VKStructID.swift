//
//  VKStructID.swift
//  VK Community
//
//  Created by Артем on 10.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import SwiftyJSON

extension VKService.Structs {
    
    // Список с идентификаторами
    class IDs {
        var count: Int
        var items: [Int]
        
        init(json: JSON) {
            count = json["count"].intValue
            items = json["items"].arrayObject as? [Int] ?? []
        }
    }
    
}
