//
//  Model.swift
//  VKService
//
//  Created by Артем on 16.05.2018.
//  Copyright © 2018 Nelmeris. All rights reserved.
//

import SwiftyJSON

class VKModel<Type: DataBaseModel>: VKBaseModel {
    
    var item: Type? = nil
    
    required convenience init(json: JSON) {
        self.init()
        item = Type(json: json[0])
    }
    
}

class VKModels<Type: DataBaseModel>: VKBaseModel {
    
    var count: Int = 0
    var items: [Type] = []
    
    public required convenience init(json: JSON) {
        self.init()
        count = json["count"].intValue
        items = json["items"].map({ Type(json: $0.1) })
    }
    
}

class VKBaseModel {
    
    required convenience init(json: JSON) {
        self.init()
    }
    
}
