//
//  VKServiceMessages.swift
//  VK X
//
//  Created by Артем Куфаев on 02/05/2019.
//  Copyright © 2019 NONE. All rights reserved.
//

import Alamofire

extension VKService {
    
    func sendMessage(dialogId: Int, messageText text: String, completionHandler: @escaping(DataResponse<_>) -> Void) {
        let request = SendMessage(baseUrl: baseUrl, dialogId: dialogId, message: text)
        self.request(request: request, completionHandler: completionHandler)
    }
    
    func getMessages(dialogId: Int, startId: Int? = nil, count: Int = 20, completionHandler: @escaping(DataResponse<VKMessagesModel>) -> Void) {
        let request = GetMessages(baseUrl: baseUrl, dialogId: dialogId, count: count, startMessageId: startId)
        self.request(request: request, completionHandler: completionHandler)
    }
    
}

extension VKService {
    
    struct SendMessage: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "messages.send"
        
        let dialogId: Int
        let message: String
        var parameters: Parameters? {
            return [
                "peer_id": dialogId,
                "message": message
            ]
        }
    }
    
    struct GetMessages: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = "messages.getHistory"
        
        let dialogId: Int
        let count: Int
        let startMessageId: Int?
        var parameters: Parameters? {
            var params = [
                "peer_id": dialogId,
                "count": count
            ]
            if let startId = startMessageId {
                params["start_message_id"] = startId
            }
            return params
        }
    }
    
}
