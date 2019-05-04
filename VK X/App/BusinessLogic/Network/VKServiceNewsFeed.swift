//
//  VKServiceNewsFeed.swift
//  VK X
//
//  Created by Артем Куфаев on 02/05/2019.
//  Copyright © 2019 NONE. All rights reserved.
//

import Alamofire

extension VKService {
    
    func getNewsFeed(type: NewsTypes, count: Int = 50, completionHandler: @escaping (DataResponse<VKNewsFeedModel>) -> Void) {
        VKTokenService.shared.getToken { token in
            let request = GetNewsFeed(baseUrl: self.baseUrl, version: self.apiVersion, token: token, filters: type, count: count)
            self.request(request: request, container: ["response"], completionHandler: completionHandler)
        }
    }
    
}

extension VKService {
    
    enum NewsTypes: String {
        case post
    }
    
    struct GetNewsFeed: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = "newsfeed.get"
        
        let version: Double
        let token: String
        
        let filters: NewsTypes
        let count: Int
        var parameters: Parameters? {
            return [
                "v": version,
                "access_token": token,
                "filters": filters.rawValue,
                "cound": count
            ]
        }
    }
    
}
