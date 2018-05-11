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

extension VKService.Requests {
    struct photos {
        
        // Вывод списка всех фото пользователя
        static func getAll(sender: UIViewController, version: VKService.Versions, parameters: [String: String] = ["" : ""], completion: @escaping(VKService.Structs.Photos) -> Void) {
            
            guard let url = VKService.RequestURL(sender, "photos.getAll", version, parameters) else { return }
            
            Alamofire.request(url.url, parameters: url.parameters).responseData { response in
                
                guard let json = VKService.GetJSON(response) else { return }
                
                let photos = VKService.Structs.Photos(json: json["response"])
                
                completion(photos)
                
            }
            
        }
        
    }
}
