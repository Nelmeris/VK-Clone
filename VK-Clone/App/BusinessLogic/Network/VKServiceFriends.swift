//
//  VKServiceFriends.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 02/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Alamofire

extension VKService {
    
    func getFriends(userId: Int? = nil, order: SortOrders? = .hints, count: Int? = nil, offset: Int? = nil, nameCase: NameCases = .nom, completionHandler: @escaping (DataResponse<[VKUserModel]>) -> Void) {
        VKTokenService.shared.get { token in
            let request = GetFriends(baseUrl: self.baseUrl, version: self.apiVersion, token: token.value, userId: userId, order: order, count: count, offset: offset, nameCase: nameCase)
            self.request(request: request, container: ["items"], completionHandler: completionHandler)
        }
    }
    
}

extension VKService {
    
    enum SortOrders: String {
        case hints, random, mobile, name
    }
    
    struct GetFriends: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = "friends.get"
        
        let version: Double
        let token: String
        
        let userId: Int?
        let order: SortOrders?
        let count: Int?
        let offset: Int?
        let fields: [UserFields] = [.photo100, .online, .photoOriginalSize, .photo50]
        let nameCase: NameCases
        var parameters: Parameters? {
            var params: [String: Any] = [
                "v": version,
                "access_token": token,
                "name_case": nameCase.rawValue
            ]
            if let userId = userId { params["user_id"] = userId }
            if let order = order { params["order"] = order.rawValue }
            if let count = count { params["count"] = count }
            if let offset = offset { params["offset"] = offset }
            var fieldsStr: [String] = []
            for element in fields {
                fieldsStr.append(element.rawValue)
            }
            params["fields"] = fieldsStr.joined(separator: ",")
            return params
        }
    }
    
}
