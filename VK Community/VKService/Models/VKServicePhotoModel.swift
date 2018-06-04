//
//  VKServicePhotoModel.swift
//  VK Community
//
//  Created by Артем on 11.05.2018.
//  Copyright © 2018 Nelmeris. All rights reserved.
//

import SwiftyJSON
import RealmSwift

class VKPhotoModel: RealmModel {
    
    @objc dynamic var id = 0
    var sizes = List<VKSizesModel>()
    
    required convenience init(_ json: JSON) {
        self.init()
        
        id = json["id"].intValue
        
        for size in json["sizes"].map({ VKSizesModel($0.1) }) {
            sizes.append(size)
        }
    }
    
    override func isEqual (_ object: RealmModel) -> Bool {
        let object = object as! VKPhotoModel
        
        guard sizes.count == object.sizes.count else { return false }
        
        for sizeIndex in 0...sizes.count - 1 {
            guard sizes[sizeIndex].isEqual(object.sizes[sizeIndex]) else { return false }
        }
        
        return id == object.id
    }
    
}
