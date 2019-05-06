//
//  VKServiceConversions.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 02/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Alamofire

extension VKService {
    
    func getConversions(offset: Int? = nil, count: Int? = nil, filters: [ConversionFilters]? = nil, extended: Bool = true, startMessageId: Int? = nil, groupId: Int? = nil, completionHandler: @escaping(DataResponse<[VKConversationModel]>) -> Void) {
        VKTokenService.shared.get { token in
            let request = GetConversions(baseUrl: self.baseUrl, version: self.apiVersion, token: token.value, offset: offset, count: count, filters: filters, extended: extended, startMessageId: startMessageId, groupId: groupId)
            self.request(request: request, delay: self.delayTime, completionHandler: completionHandler)
        }
    }
    
}

extension VKService {
    
    enum ConversionFilters: String {
        case all, unread, important, unanswered
    }
    
    struct GetConversions: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = "messages.getConversations"
        
        let version: Double
        let token: String
        
        let offset: Int?
        let count: Int?
        let filters: [ConversionFilters]?
        let extended: Bool
        let startMessageId: Int?
        let fields: ([UserFields], [GroupFields]) = ([.online, .photo100, .photo50, .photoOriginalSize], [.membersCount])
        let groupId: Int?
        var parameters: Parameters? {
            var params: [String: Any] = [
                "v": version,
                "access_token": token,
                "extended": extended
            ]
            if let offset = offset { params["offset"] = offset }
            if let count = count { params["count"] = count }
            if let startMessageId = startMessageId { params["start_message_id"] = startMessageId }
            if let groupId = groupId { params["group_id"] = groupId }
            var fieldsStr: [String] = []
            for element in fields.0 {
                fieldsStr.append(element.rawValue)
            }
            for element in fields.1 {
                fieldsStr.append(element.rawValue)
            }
            params["fields"] = fieldsStr.joined(separator: ",")
            if let filters = filters {
                var filtersStr: [String] = []
                for element in filters {
                    filtersStr.append(element.rawValue)
                }
                params["filter"] = filtersStr.joined(separator: ",")
            }
            return params
        }
    }
    
}
