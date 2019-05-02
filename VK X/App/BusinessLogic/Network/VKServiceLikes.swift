//
//  VKServiceLikes.swift
//  VK X
//
//  Created by Артем Куфаев on 02/05/2019.
//  Copyright © 2019 NONE. All rights reserved.
//

import Alamofire

extension VKService {
    
    func addLike(type: LikeTypes, itemId: Int, authorId: Int, completionHandler: @escaping(DataResponse<_>) -> Void) {
        let request = Like(baseUrl: baseUrl, action: .add, type: type, itemId: itemId, authorId: authorId)
        self.request(request: request, completionHandler: completionHandler)
    }
    
    func deleteLike(type: LikeTypes, itemId: Int, authorId: Int, completionHandler: @escaping(DataResponse<_>) -> Void) {
        let request = Like(baseUrl: baseUrl, action: .delete, type: type, itemId: itemId, authorId: authorId)
        self.request(request: request, completionHandler: completionHandler)
    }
    
}

extension VKService {
    
    enum LikeTypes: String {
        case post
    }
    
    enum LikeActions: String {
        case add, delete
    }
    
    struct Like: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        var path: String {
            return "likes." + action.rawValue
        }
        
        let action: LikeActions
        let type: LikeTypes
        let itemId: Int
        let authorId: Int
        var parameters: Parameters? {
            return [
                "type": type.rawValue,
                "item_id": itemId,
                "owner_id": authorId
            ]
        }
    }
    
}
