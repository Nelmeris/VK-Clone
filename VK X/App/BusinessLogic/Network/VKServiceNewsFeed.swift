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
        let request = GetNewsFeed(baseUrl: baseUrl, filters: type, count: count)
        self.request(request: request, completionHandler: completionHandler)
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
        
        let filters: NewsTypes
        let count: Int
        var parameters: Parameters? {
            return [
                "filters": filters.rawValue,
                "cound": count
            ]
        }
    }
    
}
