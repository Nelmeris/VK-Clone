//
//  DataBaseModel.swift
//  VK Community
//
//  Created by Артем on 20.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import SwiftyJSON
import RealmSwift

// Родитель всех типов запросов
open class DataBaseModel: Object {
    
    public required convenience init(json: JSON) {
        self.init()
    }
    
}
