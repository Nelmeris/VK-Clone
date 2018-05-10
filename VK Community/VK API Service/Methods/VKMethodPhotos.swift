//
//  VKMethodPhotos.swift
//  VK Community
//
//  Created by Артем on 11.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

extension VKService.Methods {
    struct photos {
        
        // Вывод списка всех фото пользователя
        static func getAll(sender: UIViewController, parameters: [String: String]? = nil, completion: @escaping(VKService.Structs.Photos) -> Void) {
            
            guard let url = VKService.RequestURL(sender, "photos.getAll", .v5_74, parameters) else {
                return
            }
            
            Alamofire.request(url).responseData { response in
                
                let json = try? JSON(data: response.value!)
                
                let photos = VKService.Structs.Photos(json: json!["response"])
                
                completion(photos)
                
            }
            
        }
        
    }
}
