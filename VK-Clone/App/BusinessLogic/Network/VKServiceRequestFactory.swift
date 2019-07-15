//
//  VKServiceRequestFactory.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 03/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Alamofire
import GoogleMaps

protocol VKServiceRequestFactory {
    
    // Secure
    func checkToken(token: String, completionHandler: @escaping(VKCheckTokenResponse) -> Void)
    
    // Users
    func getCurrentUser(nameCase: VKService.NameCases, completionHandler: @escaping(VKUserModel) -> Void)
    func getUsers(userIds: [Int], nameCase: VKService.NameCases, completionHandler: @escaping([VKUserModel]) -> Void)
    
    // News
    func getNewsFeed(types: [VKService.NewsTypes]?, count: Int?, completionHandler: @escaping (VKNewsFeedModel) -> Void)
    func postWall(message: String?, place: CLLocationCoordinate2D?, completionHandler: @escaping(VKPostWallResponse) -> Void)
    func addLike(type: VKService.LikeTypes, itemId: Int, authorId: Int, completionHandler: @escaping(VKLikeResponse) -> Void)
    func deleteLike(type: VKService.LikeTypes, itemId: Int, authorId: Int, completionHandler: @escaping(VKLikeResponse) -> Void)
    
    // Messages
    func getConversions(offset: Int?, count: Int?, filters: [VKService.ConversionFilters]?, extended: Bool, startMessageId: Int?, groupId: Int?, completionHandler: @escaping([VKConversationModel]) -> Void)
    func sendMessage(dialogId: Int, messageText text: String, completionHandler: @escaping(VKServiceStatusModel) -> Void)
    
    // Friends
    func getFriends(userId: Int?, order: VKService.SortOrders?, count: Int?, offset: Int?, nameCase: VKService.NameCases, completionHandler: @escaping ([VKUserModel]) -> Void)
    func getOwnerPhotos(ownerId: Int?, completionHandler: @escaping([VKPhotoModel]) -> Void)
    
    // Groups
    func getGroups(userId: Int?, extended: Bool, filters: [VKService.GroupFilters]?, offset: Int?, count: Int?, completionHandler: @escaping ([VKGroupModel]) -> Void)
    func searchGroups(searchText q: String, offset: Int?, count: Int?, completionHandler: @escaping ([VKGroupModel]) -> Void)
    func joinGroup(groupId: Int, completionHandler: @escaping (Int) -> Void)
    func leaveGroup(groupId: Int, completionHandler: @escaping (Int) -> Void)
    
}
