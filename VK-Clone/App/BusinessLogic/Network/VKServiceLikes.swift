//
//  VKServiceLikes.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 02/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Alamofire

protocol VKServiceLikesInterface {
    func addLike(type: VKService.LikeTypes, itemId: Int, authorId: Int, completionHandler: @escaping(VKLikeResponse) -> Void)
    func deleteLike(type: VKService.LikeTypes, itemId: Int, authorId: Int, completionHandler: @escaping(VKLikeResponse) -> Void)
}

extension VKService {
    
    func addLike(type: LikeTypes, itemId: Int, authorId: Int, completionHandler: @escaping(VKLikeResponse) -> Void = {_ in}) {
        VKTokenService.shared.get { token in
            let request = Like(baseUrl: self.baseUrl, version: self.apiVersion, token: token.value, action: LikeActions.add, type: type, itemId: itemId, authorId: authorId)
            self.request(request: request, completionHandler: completionHandler)
        }
    }
    
    func deleteLike(type: LikeTypes, itemId: Int, authorId: Int, completionHandler: @escaping(VKLikeResponse) -> Void = {_ in}) {
        VKTokenService.shared.get { token in
            let request = Like(baseUrl: self.baseUrl, version: self.apiVersion, token: token.value, action: .delete, type: type, itemId: itemId, authorId: authorId)
            self.request(request: request, completionHandler: completionHandler)
        }
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
        
        let version: Double
        let token: String
        
        let action: LikeActions
        let type: LikeTypes
        let itemId: Int
        let authorId: Int
        var parameters: Parameters? {
            return [
                "v": version,
                "access_token": token,
                "type": type.rawValue,
                "item_id": itemId,
                "owner_id": authorId
            ]
        }
    }
    
}
