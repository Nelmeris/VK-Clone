//
//  VKServiceGroups.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 02/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Alamofire

protocol VKServiceGroupsInterface {
    func getGroups(userId: Int?, extended: Bool, filters: [VKService.GroupFilters]?, offset: Int?, count: Int?, completionHandler: @escaping ([VKGroupModel]) -> Void)
    func searchGroups(searchText q: String, offset: Int?, count: Int?, completionHandler: @escaping ([VKGroupModel]) -> Void)
    func joinGroup(groupId: Int, completionHandler: @escaping (Int) -> Void)
    func leaveGroup(groupId: Int, completionHandler: @escaping (Int) -> Void)
}

extension VKService {
    
    func getGroups(userId: Int? = nil, extended: Bool = true, filters: [GroupFilters]? = nil, offset: Int? = nil, count: Int? = nil, completionHandler: @escaping ([VKGroupModel]) -> Void) {
        VKTokenService.shared.get { token in
            let request = GetGroups(baseUrl: self.baseUrl, version: self.apiVersion, token: token.value, userId: userId, extended: extended, filters: filters, offset: offset, count: count)
            self.request(request: request) { (response: VKResponseItems<[VKGroupModel]>) in
                completionHandler(response.items)
            }
        }
    }
    
    func searchGroups(searchText q: String, offset: Int? = nil, count: Int? = nil, completionHandler: @escaping ([VKGroupModel]) -> Void) {
        VKTokenService.shared.get { token in
            let request = SearchGroups(baseUrl: self.baseUrl, version: self.apiVersion, token: token.value, offset: offset, count: count, sort: "0", q: q)
            self.request(request: request) { (response: VKResponseItems<[VKGroupModel]>) in
                completionHandler(response.items)
            }
        }
    }
    
    func joinGroup(groupId: Int, completionHandler: @escaping (Int) -> Void = {_ in}) {
        VKTokenService.shared.get { token in
            let request = JoinGroup(baseUrl: self.baseUrl, version: self.apiVersion, token: token.value, groupId: groupId)
            self.request(request: request, completionHandler: completionHandler)
        }
    }
    
    func leaveGroup(groupId: Int, completionHandler: @escaping (Int) -> Void) {
        VKTokenService.shared.get { token in
            let request = LeaveGroup(baseUrl: self.baseUrl, version: self.apiVersion, token: token.value, groupId: groupId)
            self.request(request: request, completionHandler: completionHandler)
        }
    }
    
}

extension VKService {
    
    enum GroupFilters: String {
        case admin, editor, moder, advertiser, groups, publics, events, hasAddress
    }
    
    enum GroupFields: String {
        case photo50 = "photo_50"
        case photo100 = "photo_100"
        case photoOriginalSize = "photo_200"
        case membersCount = "members_count"
    }
    
    struct GetGroups: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = "groups.get"
        
        let version: Double
        let token: String
        
        let userId: Int?
        let extended: Bool
        let filters: [GroupFilters]?
        let fields: [GroupFields] = [.photo50, .photo100, .photoOriginalSize, .membersCount]
        let offset: Int?
        let count: Int?
        var parameters: Parameters? {
            var params: [String: Any] = [
                "v": version,
                "access_token": token,
                "extended": extended ? 1 : 0
            ]
            var filtersStr: [String] = []
            if let filters = filters {
                for element in filters {
                    filtersStr.append(element.rawValue)
                }
            }
            params["filter"] = filtersStr.joined(separator: ",")
            var fieldsStr: [String] = []
            for element in fields {
                fieldsStr.append(element.rawValue)
            }
            params["fields"] = fieldsStr.joined(separator: ",")
            if let userId = userId { params["user_id"] = userId }
            if let offset = offset { params["offset"] = offset }
            if let count = count { params["count"] = count }
            return params
        }
    }
    
    struct SearchGroups: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = "groups.search"
        
        let version: Double
        let token: String
        
        let offset: Int?
        let count: Int?
        
        let fields: [GroupFields] = [.photo50, .photo100, .photoOriginalSize, .membersCount]
        let sort: String
        let q: String
        var parameters: Parameters? {
            var params: [String: Any] = [
                "v": version,
                "access_token": token,
                "sort": sort,
                "q": q
            ]
            var fieldsStr: [String] = []
            for element in fields {
                fieldsStr.append(element.rawValue)
            }
            params["fields"] = fieldsStr.joined(separator: ",")
            if let offset = offset { params["offset"] = offset}
            if let count = count { params["count"] = count}
            return params
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
