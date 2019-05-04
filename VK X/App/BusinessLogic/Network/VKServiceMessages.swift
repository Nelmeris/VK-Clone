//
//  VKServiceMessages.swift
//  VK X
//
//  Created by Артем Куфаев on 02/05/2019.
//  Copyright © 2019 NONE. All rights reserved.
//

import Alamofire

extension VKService {
    
    func sendMessage(dialogId: Int, messageText text: String, completionHandler: @escaping(DataResponse<VKServiceStatusModel>) -> Void) {
        VKTokenService.shared.getToken { token in
            let request = SendMessage(baseUrl: self.baseUrl, version: self.apiVersion, token: token, dialogId: dialogId, message: text)
            self.request(request: request, completionHandler: completionHandler)
        }
    }
    
    func getMessages(dialogId: Int, startId: Int? = nil, count: Int = 20, completionHandler: @escaping(DataResponse<VKMessagesModel>) -> Void) {
        VKTokenService.shared.getToken { token in
            let request = GetMessages(baseUrl: self.baseUrl, version: self.apiVersion, token: token, dialogId: dialogId, count: count, startMessageId: startId)
                self.request(request: request, completionHandler: completionHandler)
        }
    }
    
    func getLongPollServer(completionHandler: @escaping(DataResponse<VKMessageLongPollServerModel>) -> Void) {
        VKTokenService.shared.getToken { token in
            let request = GetLongPollServer(baseUrl: self.baseUrl, version: self.apiVersion, token: token)
                self.request(request: request, completionHandler: completionHandler)
        }
    }
    
}

extension VKService {
    
    struct SendMessage: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "messages.send"
        
        let version: Double
        let token: String
        
        let dialogId: Int
        let message: String
        var parameters: Parameters? {
            return [
                "v": version,
                "access_token": token,
                "peer_id": dialogId,
                "message": message
            ]
        }
    }
    
    struct GetMessages: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = "messages.getHistory"
        
        let version: Double
        let token: String
        
        let dialogId: Int
        let count: Int
        let startMessageId: Int?
        var parameters: Parameters? {
            var params: [String: Any] = [
                "v": version,
                "access_token": token,
                "peer_id": dialogId,
                "count": count
            ]
            if let startId = startMessageId {
                params["start_message_id"] = startId
            }
            return params
        }
    }
    
    struct GetLongPollServer: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = "messages.getLongPollServer"
        
        let version: Double
        let token: String
        
        var parameters: Parameters? {
            return [
                "v": version,
                "access_token": token
            ]
        }
    }
    
}
