//
//  VKServiceWall.swift
//  VK X
//
//  Created by Артем Куфаев on 02/05/2019.
//  Copyright © 2019 NONE. All rights reserved.
//

import Alamofire
import GoogleMaps

extension VKService {
    
    func postWall(text: String?, place: CLLocationCoordinate2D?, completionHandler: @escaping(DataResponse<_>) -> Void) {
        let request = PostWall(baseUrl: baseUrl, text: text, place: place)
        self.request(request: request, completionHandler: completionHandler)
    }
    
}

extension VKService {
    
    struct PostWall: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "wall.post"
        
        let text: String?
        let place: CLLocationCoordinate2D?
        var parameters: Parameters? {
            var params = [String: String]()
            if text != nil {
                params["text"] = text
            }
            if place != nil {
                params["lat"] = String(place!.latitude)
                params["lon"] = String(place!.longitude)
            }
            return params
        }
    }
    
}
