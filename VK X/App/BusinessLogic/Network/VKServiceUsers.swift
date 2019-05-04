//
//  VKServiceUsers.swift
//  VK X
//
//  Created by Артем Куфаев on 02/05/2019.
//  Copyright © 2019 NONE. All rights reserved.
//

import Alamofire

extension VKService {
    
    func getUser(completionHandler: @escaping(DataResponse<VKSoloUserModel>) -> Void) {
        VKTokenService.shared.getToken { token in
            let request = GetUsers(baseUrl: self.baseUrl, version: self.apiVersion, token: token, fields: "photo_100")
            self.request(request: request, container: ["response"], completionHandler: completionHandler)
        }
    }
    
}

extension VKService {
    
    struct GetUsers: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = "users.get"
        
        let version: Double
        let token: String
        
        let fields: String
        var parameters: Parameters? {
            var params: [String: Any] = [
                "v": version,
                "access_token": token,
                "fields": fields
            ]
            return params
        }
    }
    
}
