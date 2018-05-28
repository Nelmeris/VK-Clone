//
//  Model.swift
//  VKService
//
//  Created by Артем on 16.05.2018.
//  Copyright © 2018 Nelmeris. All rights reserved.
//

import SwiftyJSON

class VKItem<Type: DataBaseModel>: VKBaseModel {
    
    var item: Type? = nil
    
    required convenience init(json: JSON) {
        self.init()
        item = Type(json: json[0])
    }
    
}

class VKItems<Type: DataBaseModel>: VKBaseModel {
    
    var count: Int = 0
    var items: [Type] = []
    
    required convenience init(json: JSON) {
        self.init()
        count = json["count"].intValue
        items = json["items"].map({ Type(json: $0.1) })
    }
    
}

class VKResponse<Type: VKBaseModel>: VKBaseModel {
    
    var response: Type! = nil
    
    required convenience init(json: JSON) {
        self.init()
        response = Type(json: json)
    }
    
}

class VKBaseModel {
    
    required convenience init(json: JSON) {
        self.init()
    }
    
}
