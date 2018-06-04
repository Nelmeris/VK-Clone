//
//  VKServiceBaseModel.swift
//  VK Community
//
//  Created by Артем on 16.05.2018.
//  Copyright © 2018 Nelmeris. All rights reserved.
//

import SwiftyJSON

class VKBaseModel {
    
    required convenience init(_ json: JSON) {
        self.init()
    }
    
}



class VKResponseModel<Type: VKBaseModel>: VKBaseModel {
    
    var response: Type!
    
    required convenience init(_ json: JSON) {
        self.init()
        
        response = Type(json)
    }
    
}

class VKItemsModel<Type: RealmModel>: VKBaseModel {
    
    var count: Int = 0
    var items: [Type] = []
    
    required convenience init(_ json: JSON) {
        self.init()
        
        count = json["count"].intValue
        items = json["items"].map({ Type($0.1) })
    }
    
}

class VKItemModel<Type: RealmModel>: VKBaseModel {
    
    var item: Type!
    
    required convenience init(_ json: JSON) {
        self.init()
        
        item = Type(json[0])
    }
    
}

class VKRealmResponseModel<Type: RealmModel>: VKBaseModel {
    
    var response: Type!
    
    required convenience init(_ json: JSON) {
        self.init()
        
        response = Type(json)
    }
    
}
