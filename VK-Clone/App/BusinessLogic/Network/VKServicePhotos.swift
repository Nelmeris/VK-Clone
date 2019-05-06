//
//  VKServicePhotos.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 02/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Alamofire

extension VKService {
    
    func getOwnerPhotos(ownerId: Int? = nil, completionHandler: @escaping(DataResponse<[VKPhotoModel]>) -> Void) {
        _ = dispatchGroup.wait(timeout: self.lastRequestTime + self.requestsDelay)
        dispatchGroup.enter()
        VKTokenService.shared.get { token in
            let request = GetOwnerPhotos(baseUrl: self.baseUrl, version: self.apiVersion, token: token, ownerId: ownerId)
            self.request(request: request, container: ["items"], completionHandler: completionHandler)
            self.lastRequestTime = DispatchTime.now()
            self.dispatchGroup.leave()
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
