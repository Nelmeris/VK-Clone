//
//  VKServiceGroups.swift
//  VK X
//
//  Created by Артем Куфаев on 02/05/2019.
//  Copyright © 2019 NONE. All rights reserved.
//

import Alamofire

extension VKService {
    
    func getGroups(completionHandler: @escaping (DataResponse<[VKGroupModel]>) -> Void) {
        VKTokenService.shared.getToken { token in
            let request = GetGroups(baseUrl: self.baseUrl, version: self.apiVersion, token: token, extended: 1)
            self.request(request: request, container: ["response", "items"], completionHandler: completionHandler)
        }
    }
    
    func joinGroup(groupId: Int, completionHandler: @escaping (DataResponse<VKServiceStatusModel>) -> Void = {_ in}) {
        VKTokenService.shared.getToken { token in
            let request = JoinGroup(baseUrl: self.baseUrl, version: self.apiVersion, token: token, groupId: groupId)
            self.request(request: request, completionHandler: completionHandler)
        }
    }
    
    func leaveGroup(groupId: Int, completionHandler: @escaping (DataResponse<VKServiceStatusModel>) -> Void) {
        VKTokenService.shared.getToken { token in
            let request = LeaveGroup(baseUrl: self.baseUrl, version: self.apiVersion, token: token, groupId: groupId)
            self.request(request: request, completionHandler: completionHandler)
        }
    }
    
    func searchGroups(searchText q: String, completionHandler: @escaping (DataResponse<[VKGroupModel]>) -> Void) {
        VKTokenService.shared.getToken { token in
            let request = SearchGroups(baseUrl: self.baseUrl, version: self.apiVersion, token: token, fields: "member_count", sort: "0", q: q)
            self.request(request: request, completionHandler: completionHandler)
        }
    }
    
}

extension VKService {
    
    struct GetGroups: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = "groups.get"
        
        let version: Double
        let token: String
        
        let extended: Int
        var parameters: Parameters? {
            return [
                "v": version,
                "access_token": token,
                "extended": extended
            ]
        }
    }
    
    struct LeaveGroup: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "groups.leave"
        
        let version: Double
        let token: String
        
        let groupId: Int
        var parameters: Parameters? {
            return [
                "v": version,
                "access_token": token,
                "group_id": groupId
            ]
        }
    }
    
    struct SearchGroups: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = "groups.search"
        
        let version: Double
        let token: String
        
        let fields: String
        let sort: String
        let q: String
        var parameters: Parameters? {
            return [
                "v": version,
                "access_token": token,
                "fields": fields,
                "sort": sort,
                "q": q
            ]
        }
    }
    
    struct JoinGroup: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "groups.join"
        
        let version: Double
        let token: String
        
        let groupId: Int
        var parameters: Parameters? {
            return [
                "v": version,
                "access_token": token,
                "group_id": groupId
            ]
        }
    }
    
}
