//
//  VKServiceUsers.swift
//  VK X
//
//  Created by Артем Куфаев on 02/05/2019.
//  Copyright © 2019 NONE. All rights reserved.
//

import Alamofire

extension VKService {
    
    func getUsers(id: Int? = nil, completionHandler: @escaping(DataResponse<VKSoloUserModel>) -> Void) {
        let request = GetUsers(baseUrl: baseUrl, fields: "photo_100", user_id: id)
        self.request(request: request, completionHandler: completionHandler)
    }
    
}

extension VKService {
    
    struct GetUsers: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = "users.get"
        
        let fields: String
        let user_id: Int?
        var parameters: Parameters? {
            var params = ["fields": fields]
            if let id = user_id {
                params["user_id"] = String(id)
            }
            return params
        }
    }
    
}
