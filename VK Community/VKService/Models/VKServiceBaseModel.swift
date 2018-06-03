//
//  Model.swift
//  VKService
//
//  Created by Артем on 16.05.2018.
//  Copyright © 2018 Nelmeris. All rights reserved.
//

import SwiftyJSON

class VKBaseModel {
    
    required convenience init(json: JSON) {
        self.init()
    }
    
}



class VKResponseModel<Type: VKBaseModel>: VKBaseModel {
    
    var response: Type!
    
    required convenience init(json: JSON) {
        self.init()
        response = Type(json: json)
    }
    
}

class VKItemsModel<Type: DataBaseModel>: VKBaseModel {
    
    var count: Int = 0
    var items: [Type] = []
    
    required convenience init(json: JSON) {
        self.init()
        count = json["count"].intValue
        items = json["items"].map({ Type(json: $0.1) })
    }
    
}

class VKItemModel<Type: DataBaseModel>: VKBaseModel {
    
    var item: Type!
    
    required convenience init(json: JSON) {
        self.init()
        item = Type(json: json[0])
    }
    
}

class VKDataBaseResponseModel<Type: DataBaseModel>: VKBaseModel {
    
    var response: Type!
    
    required convenience init(json: JSON) {
        self.init()
        response = Type(json: json)
    }
    
}
