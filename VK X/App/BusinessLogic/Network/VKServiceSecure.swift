//
//  VKServiceSecure.swift
//  VK X
//
//  Created by Artem Kufaev on 03/05/2019.
//  Copyright © 2019 NONE. All rights reserved.
//

import Alamofire

extension VKService {
    
    func checkToken(completionHandler: @escaping(DataResponse<VKServiceCheckTokenResponse>) -> Void) {
        VKTokenService.shared.getToken { token in
            let request = CheckToken(baseUrl: self.baseUrl, version: self.apiVersion, token: token)
            self.request(request: request, completionHandler: completionHandler)
        }
    }
    
}

extension VKService {
    
    struct CheckToken: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = "secure.checkToken"
        
        let version: Double
        let token: String
        
        var parameters: Parameters? {
            return [
                "v": version,
                "token": token
            ]
        }
    }
    
}
