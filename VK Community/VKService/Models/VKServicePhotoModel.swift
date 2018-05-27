//
//  Photo.swift
//  VKService
//
//  Created by Артем on 11.05.2018.
//  Copyright © 2018 Nelmeris. All rights reserved.
//

import SwiftyJSON

// Данные фотографии
class VKPhoto: DataBaseModel {
    
    @objc dynamic var id = 0
    @objc dynamic var photo_75 = ""
    @objc dynamic var photo_130 = ""
    
    required convenience init(json: JSON) {
        self.init()
        
        self.id = json["id"].intValue
        self.photo_75 = json["photo_75"].stringValue
        self.photo_130 = json["photo_130"].stringValue
    }
    
    override func isEqual (_ object: DataBaseModel) -> Bool {
        let object = object as! VKPhoto
        return (self.id == object.id) &&
            (self.photo_75 == object.photo_75) &&
            (self.photo_130 == object.photo_130)
    }
    
}
