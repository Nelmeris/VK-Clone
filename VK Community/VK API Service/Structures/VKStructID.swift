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
    class IDs: VKService.Structs {
        @objc dynamic var count = 0
        @objc dynamic var items: [Int] = []
        
        convenience init(json: JSON) {
            self.init(json: json)
            self.count = json["count"].intValue
            self.items = json["items"].arrayObject as? [Int] ?? []
        }
    }
    
}
