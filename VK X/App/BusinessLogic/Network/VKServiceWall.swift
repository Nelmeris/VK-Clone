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
    
    func postWall(text: String?, place: CLLocationCoordinate2D?, completionHandler: @escaping(DataResponse<VKServiceStatusModel>) -> Void) {
        VKTokenService.shared.getToken { token in
            let request = PostWall(baseUrl: self.baseUrl, version: self.apiVersion, token: token, text: text, place: place)
            self.request(request: request, completionHandler: completionHandler)
        }
    }
    
}

extension VKService {
    
    struct PostWall: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "wall.post"
        
        let version: Double
        let token: String
        
        let text: String?
        let place: CLLocationCoordinate2D?
        var parameters: Parameters? {
            var params: [String: Any] = [
                "v": version,
                "access_token": token
            ]
            if text != nil {
                params["text"] = text
            }
            if place != nil {
                params["lat"] = place!.latitude
                params["lon"] = place!.longitude
            }
            return params
        }
    }
    
}
