//
//  VKServiceGroups.swift
//  VK X
//
//  Created by Артем Куфаев on 02/05/2019.
//  Copyright © 2019 NONE. All rights reserved.
//

import Alamofire

extension VKService {
    
    func getGroups(completionHandler: @escaping (DataResponse<VKGroupsModel>) -> Void) {
        let request = GetGroups(baseUrl: baseUrl, extended: 1)
        self.request(request: request, completionHandler: completionHandler)
    }
    
    func joinGroup(groupId: Int, completionHandler: @escaping (DataResponse<_>) -> Void) {
        let request = JoinGroup(baseUrl: baseUrl, groupId: groupId)
        self.request(request: request, completionHandler: completionHandler)
    }
    
    func leaveGroup(groupId: Int, completionHandler: @escaping (DataResponse<_>) -> Void) {
        let request = LeaveGroup(baseUrl: baseUrl, groupId: groupId)
        self.request(request: request, completionHandler: completionHandler)
    }
    
    func searchGroups(searchText q: String, completionHandler: @escaping (DataResponse<[VKGroupModel]>) -> Void) {
        let request = SearchGroups(baseUrl: baseUrl, fields: "member_count", sort: "0", q: q)
        self.request(request: request, completionHandler: completionHandler)
    }
    
}

extension VKService {
    
    struct GetGroups: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = "groups.get"
        
        let extended: Int
        var parameters: Parameters? {
            return [
                "extended": extended
            ]
        }
    }
    
    struct LeaveGroup: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "groups.leave"
        
        let groupId: Int
        var parameters: Parameters? {
            return [
                "group_id": groupId
            ]
        }
    }
    
    struct SearchGroups: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = "groups.search"
        
        let fields: String
        let sort: String
        let q: String
        var parameters: Parameters? {
            return [
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
        
        let groupId: Int
        var parameters: Parameters? {
            return [
                "group_id": groupId
            ]
        }
    }
    
}
