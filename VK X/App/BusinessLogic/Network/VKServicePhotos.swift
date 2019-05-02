//
//  VKServicePhotos.swift
//  VK X
//
//  Created by Артем Куфаев on 02/05/2019.
//  Copyright © 2019 NONE. All rights reserved.
//

import Alamofire

extension VKService {
    
    func getAllPhotos(ownerId: Int, completionHandler: @escaping(DataResponse<VKPhotosModel>) -> Void) {
        let request = getAllPhotos(ownerId: ownerId, completionHandler: completionHandler)
    }
    
}

extension VKService {
    
    struct GetAllPhotos: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = "photos.getAll"
        
        let ownerId: Int
        var parameters: Parameters? {
            return [
                "owner_id": ownerId
            ]
        }
    }
    
}
