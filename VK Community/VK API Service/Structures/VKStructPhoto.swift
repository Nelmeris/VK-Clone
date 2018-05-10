//
//  VKStructPhoto.swift
//  VK Community
//
//  Created by Артем on 11.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import SwiftyJSON

extension VKService.Structs {
    
    // Список фотографий
    class Photos {
        var count: Int
        var items: [Photo]
        
        init(json: JSON) {
            count = json["count"].intValue
            items = json["items"].map { Photo(json: $0.1)}
        }
    }
    
    // Данные фотографии
    class Photo {
        var id: Int
        var photo_75 = ""
        var photo_130 = ""
        
        init(json: JSON) {
            id = json["id"].intValue
            photo_75 = json["photo_75"].stringValue
            photo_130 = json["photo_130"].stringValue
        }
    }
    
}
