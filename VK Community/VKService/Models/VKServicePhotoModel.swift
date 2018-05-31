//
//  Photo.swift
//  VKService
//
//  Created by Артем on 11.05.2018.
//  Copyright © 2018 Nelmeris. All rights reserved.
//

import SwiftyJSON
import RealmSwift

// Данные фотографии
class VKPhotoModel: DataBaseModel {
    
    @objc dynamic var id = 0
    var sizes = List<VKSizes>()
    
    required convenience init(json: JSON) {
        self.init()
        
        self.id = json["id"].intValue
        let sizes = json["sizes"].map({ VKSizes($0.1) })
        for size in sizes {
            self.sizes.append(size)
        }
    }
    
    override func isEqual (_ object: DataBaseModel) -> Bool {
        let object = object as! VKPhotoModel
        
        guard sizes.count == object.sizes.count else {
            return false
        }
        
        for sizeIndex in 0...sizes.count - 1 {
            guard sizes[sizeIndex].isEqual(object.sizes[sizeIndex]) else {
                return false
            }
        }
        
        return self.id == object.id
    }
    
}
