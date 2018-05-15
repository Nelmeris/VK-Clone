//
//  VKStructPhoto.swift
//  VK Community
//
//  Created by Артем on 11.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import SwiftyJSON

// Данные фотографии
class Photo: Structures {
    
    @objc dynamic var id = 0
    @objc dynamic var photo_75 = ""
    @objc dynamic var photo_130 = ""
    
    convenience required init(json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.photo_75 = json["photo_75"].stringValue
        self.photo_130 = json["photo_130"].stringValue
    }
    
}
