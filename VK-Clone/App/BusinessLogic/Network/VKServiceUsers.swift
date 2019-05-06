//
//  VKServiceUsers.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 02/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Alamofire

// https://vk.com/dev/users.get

extension VKService {
    
    func getCurrentUser(nameCase: NameCases = .nom, completionHandler: @escaping(DataResponse<VKUserModel>) -> Void) {
        VKTokenService.shared.get { token in
            let request = GetUsers(baseUrl: self.baseUrl, version: self.apiVersion, token: token.value, userIds: nil, nameCase: nameCase)
            self.request(request: request, completionHandler: completionHandler)
        }
    }
    
    func getUsers(userIds: [Int], nameCase: VKService.NameCases = .nom, completionHandler: @escaping(DataResponse<[VKUserModel]>) -> Void) {
        VKTokenService.shared.get { token in
            let request = GetUsers(baseUrl: self.baseUrl, version: self.apiVersion, token: token.value, userIds: userIds, nameCase: nameCase)
            self.request(request: request, completionHandler: completionHandler)
        }
    }
    
}

extension VKService {
    
    enum NameCases: String {
        case nom, gen, dat, acc, ins, abl
    }
    
    enum UserFields: String {
        case photo50 = "photo_50"
        case photo100 = "photo_100"
        case photoOriginalSize = "photo_200"
        case online
    }
    
    struct GetUsers: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = "users.get"
        
        let version: Double
        let token: String
        
        let userIds: [Int]?
        let fields: [UserFields] = [.photo50, .photo100, .photoOriginalSize, .online]
        let nameCase: NameCases
        var parameters: Parameters? {
            var params: [String: Any] = [
                "v": version,
                "access_token": token,
                "name_case": nameCase.rawValue
            ]
            var fieldsStr: [String] = []
            for element in fields {
                fieldsStr.append(element.rawValue)
            }
            if let userIds = userIds { params["user_ids"] = userIds }
            params["fields"] = fieldsStr.joined(separator: ",")
            return params
        }
    }
    
}
