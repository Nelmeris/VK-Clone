//
//  Model.swift
//  VKService
//
//  Created by Артем on 16.05.2018.
//  Copyright © 2018 Nelmeris. All rights reserved.
//

import SwiftyJSON

open class VKModel<Type: DataBaseModel>: VKBaseModel {
    
    public var item: Type? = nil
    
    public required convenience init(json: JSON) {
        self.init()
        item = Type(json: json[0])
    }
    
}

open class VKModels<Type: DataBaseModel>: VKBaseModel {
    
    public var count: Int = 0
    public var items: [Type] = []
    
    public required convenience init(json: JSON) {
        self.init()
        count = json["count"].intValue
        items = json["items"].map({ Type(json: $0.1) })
    }
    
}

open class VKBaseModel {
    
    public required convenience init(json: JSON) {
        self.init()
    }
    
}
