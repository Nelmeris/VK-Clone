//
//  VKStructID.swift
//  VK Community
//
//  Created by Артем on 10.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import SwiftyJSON

struct ID {
    var id: Int
    
    init(json: JSON) {
        id = json.intValue
    }
}
