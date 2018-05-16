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
open class Photo: Models {
    
    @objc dynamic public var id = 0
    @objc dynamic public var photo_75 = ""
    @objc dynamic public var photo_130 = ""
    
    public required convenience init(json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.photo_75 = json["photo_75"].stringValue
        self.photo_130 = json["photo_130"].stringValue
    }
    
}
