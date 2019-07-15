//
//  VKServiceNewsFeed.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 02/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Alamofire

extension VKService {
    
    func getNewsFeed(types: [NewsTypes]? = nil, count: Int? = nil, completionHandler: @escaping (VKNewsFeedModel) -> Void) {
        VKTokenService.shared.get { token in
            let request = GetNewsFeed(baseUrl: self.baseUrl, version: self.apiVersion, token: token.value, filters: types, count: count)
            self.request(request: request, completionHandler: completionHandler)
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
        
        let filters: [NewsTypes]?
        let count: Int?
        var parameters: Parameters? {
            var params: [String: Any] = [
                "v": version,
                "access_token": token
            ]
            if let filters = filters {
                var filtersStr: [String] = []
                for element in filters {
                    filtersStr.append(element.rawValue)
                }
                params["filters"] = filtersStr.joined(separator: ",")
            }
            
            if let count = count { params["count"] = count }
            return params
        }
    }
    
}
