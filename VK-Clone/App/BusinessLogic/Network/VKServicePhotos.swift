//
//  VKServicePhotos.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 02/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Alamofire

extension VKService {
    
    func getOwnerPhotos(ownerId: Int? = nil, completionHandler: @escaping([VKPhotoModel]) -> Void) {
        VKTokenService.shared.get { token in
            let request = GetOwnerPhotos(baseUrl: self.baseUrl, version: self.apiVersion, token: token.value, ownerId: ownerId)
            self.request(request: request) { (response: VKResponseItems<[VKPhotoModel]>) in
                completionHandler(response.items)
            }
        }
    }
    
}

extension VKService {
    
    struct GetOwnerPhotos: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = "photos.getAll"
        
        let version: Double
        let token: String
        
        let ownerId: Int?
        var parameters: Parameters? {
            var params: [String: Any] = [
                "v": version,
                "access_token": token
            ]
            if let ownerId = ownerId { params["owner_id"] = ownerId }
            return params
        }
    }
    
}
