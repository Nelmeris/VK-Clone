//
//  VKServiceLoggerProxy.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 03.02.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import GoogleMaps

class VKServiceSecureLoggerProxy: VKServiceSecureInterface {
    func checkToken(token: String, completionHandler: @escaping (VKCheckTokenResponse) -> Void) {
        LoggerInvoker.shared.addLogCommand(LogCommand(action: .networkRequest(query: "Verifying the validity of the token")))
        VKService.shared.checkToken(token: token, completionHandler: completionHandler)
    }
}

class VKServiceUsersLoggerProxy: VKServiceUsersInterface {
    func getCurrentUser(nameCase: VKService.NameCases = .nom, completionHandler: @escaping (VKUserModel) -> Void) {
        let query = "Get current user with name case \(nameCase)"
        // TODO
        LoggerInvoker.shared.addLogCommand(LogCommand(action: .networkRequest(query: query)))
        VKService.shared.getCurrentUser(nameCase: nameCase, completionHandler: completionHandler)
    }
    
    func getUsers(userIds: [Int], nameCase: VKService.NameCases = .nom, completionHandler: @escaping([VKUserModel]) -> Void) {
        let query = "Get users with IDs \(userIds) and name case \(nameCase)"
        // TODO
        LoggerInvoker.shared.addLogCommand(LogCommand(action: .networkRequest(query: query)))
        VKService.shared.getUsers(userIds: userIds, nameCase: nameCase, completionHandler: completionHandler)
    }
}

class VKServiceFriendsLoggerProxy: VKServiceFriendsInterface {
    func getFriends(userId: Int? = nil, order: VKService.SortOrders? = .hints, count: Int? = nil, offset: Int? = nil, nameCase: VKService.NameCases = .nom, completionHandler: @escaping ([VKUserModel]) -> Void) {
        let query = "Get friends"
        // TODO
        LoggerInvoker.shared.addLogCommand(LogCommand(action: .networkRequest(query: query)))
        VKService.shared.getFriends(userId: userId, order: order, count: count, offset: offset, nameCase: nameCase, completionHandler: completionHandler)
    }
}

class VKServiceGroupsLoggerProxy: VKServiceGroupsInterface {
    func getGroups(userId: Int? = nil, extended: Bool = true, filters: [VKService.GroupFilters]? = nil, offset: Int? = nil, count: Int? = nil, completionHandler: @escaping ([VKGroupModel]) -> Void) {
        let query = "Get groups"
        // TODO
        LoggerInvoker.shared.addLogCommand(LogCommand(action: .networkRequest(query: query)))
        VKService.shared.getGroups(userId: userId, extended: extended, filters: filters, offset: offset, count: count, completionHandler: completionHandler)
    }
    
    func searchGroups(searchText q: String, offset: Int? = nil, count: Int? = nil, completionHandler: @escaping ([VKGroupModel]) -> Void) {
        let query = "Search groups with title \"\(q)\""
        // TODO
        LoggerInvoker.shared.addLogCommand(LogCommand(action: .networkRequest(query: query)))
        VKService.shared.searchGroups(searchText: q, offset: offset, count: count, completionHandler: completionHandler)
    }
    
    func joinGroup(groupId: Int, completionHandler: @escaping (Int) -> Void = {_ in}) {
        let query = "Join the group \(groupId)"
        LoggerInvoker.shared.addLogCommand(LogCommand(action: .networkRequest(query: query)))
        VKService.shared.joinGroup(groupId: groupId, completionHandler: completionHandler)
    }
    
    func leaveGroup(groupId: Int, completionHandler: @escaping (Int) -> Void) {
        let query = "Leave from the group \(groupId)"
        LoggerInvoker.shared.addLogCommand(LogCommand(action: .networkRequest(query: query)))
        VKService.shared.leaveGroup(groupId: groupId, completionHandler: completionHandler)
    }
}

class VKServiceNewsFeedLoggerProxy: VKServiceNewsFeedInterface {
    func getNewsFeed(types: [VKService.NewsTypes]? = nil, count: Int? = nil, completionHandler: @escaping (VKNewsFeedModel) -> Void) {
        let query = "Get news feed"
        LoggerInvoker.shared.addLogCommand(LogCommand(action: .networkRequest(query: query)))
        VKService.shared.getNewsFeed(types: types, count: count, completionHandler: completionHandler)
    }
}

class VKServiceLikesLoggerProxy: VKServiceLikesInterface {
    func addLike(type: VKService.LikeTypes, itemId: Int, authorId: Int, completionHandler: @escaping(VKLikeResponse) -> Void = {_ in}) {
        let query = "Add like type \(type) on item ID \(itemId) and author ID \(authorId)"
        LoggerInvoker.shared.addLogCommand(LogCommand(action: .networkRequest(query: query)))
        VKService.shared.deleteLike(type: type, itemId: itemId, authorId: authorId, completionHandler: completionHandler)
    }
    
    func deleteLike(type: VKService.LikeTypes, itemId: Int, authorId: Int, completionHandler: @escaping(VKLikeResponse) -> Void = {_ in}) {
        let query = "Delete like type \(type) from item ID \(itemId) for author ID \(authorId)"
        LoggerInvoker.shared.addLogCommand(LogCommand(action: .networkRequest(query: query)))
        VKService.shared.deleteLike(type: type, itemId: itemId, authorId: authorId, completionHandler: completionHandler)
    }
}

class VKServiceConversionsLoggerProxy: VKServiceConversionsInterface {
    func getConversions(offset: Int? = nil, count: Int? = nil, filters: [VKService.ConversionFilters]? = nil, extended: Bool = true, startMessageId: Int? = nil, groupId: Int? = nil, completionHandler: @escaping([VKConversationModel]) -> Void) {
        let query = "Get conversions"
        // TODO
        LoggerInvoker.shared.addLogCommand(LogCommand(action: .networkRequest(query: query)))
        VKService.shared.getConversions(offset: offset, count: count, filters: filters, extended: extended, startMessageId: startMessageId, groupId: groupId, completionHandler: completionHandler)
    }
}

class VKServicePhotosLoggerProxy: VKServicePhotosInterface {
    func getOwnerPhotos(ownerId: Int? = nil, completionHandler: @escaping([VKPhotoModel]) -> Void) {
        var action: LogAction!
        if let id = ownerId {
            action = .networkRequest(query: "Get photos of the user ID \(id)")
        } else {
            action = .networkRequest(query: "Get photos of the current user")
        }
        LoggerInvoker.shared.addLogCommand(LogCommand(action: action))
        VKService.shared.getOwnerPhotos(ownerId: ownerId, completionHandler: completionHandler)
    }
}

class VKServiceWallLoggerProxy: VKServiceWallInterface {
    func postWall(message: String?, place: CLLocationCoordinate2D?, completionHandler: @escaping(VKPostWallResponse) -> Void = {_ in}) {
        var query = "Post wall"
        if let message = message {
            query += ", with text \"\(message)\""
        }
        if let place = place {
            query += ", on place \"\(place.longitude) \(place.latitude)\""
        }
        LoggerInvoker.shared.addLogCommand(LogCommand(action: .networkRequest(query: query)))
        VKService.shared.postWall(message: message, place: place, completionHandler: completionHandler)
    }
}
