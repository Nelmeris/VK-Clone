//
//  DataBaseModel.swift
//  VK Community
//
//  Created by Артем on 20.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import SwiftyJSON
import RealmSwift

class RealmModel: Object {
    
    required convenience init(_ json: JSON) {
        self.init()
    }
    
    func isEqual (_ object: RealmModel) -> Bool {
        return false
    }
    
}
