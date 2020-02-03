//
//  VKServiceWall.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 02/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Alamofire
import GoogleMaps

protocol VKServiceWallInterface {
    func postWall(message: String?, place: CLLocationCoordinate2D?, completionHandler: @escaping(VKPostWallResponse) -> Void)
}

extension VKService {
    
    func postWall(message: String?, place: CLLocationCoordinate2D?, completionHandler: @escaping(VKPostWallResponse) -> Void = {_ in}) {
        VKTokenService.shared.get { token in
            let request = PostWall(baseUrl: self.baseUrl, version: self.apiVersion, token: token.value, message: message, place: place)
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
        
        let message: String?
        let place: CLLocationCoordinate2D?
        var parameters: Parameters? {
            var params: [String: Any] = [
                "v": version,
                "access_token": token
            ]
            if let message = message {
                params["message"] = message
            }
            if let place = place {
                params["lat"] = place.latitude
                params["long"] = place.longitude
            }
            return params
        }
    }
    
}
