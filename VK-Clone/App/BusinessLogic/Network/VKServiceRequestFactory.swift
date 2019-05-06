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
    func checkToken(token: String, completionHandler: @escaping(DataResponse<VKCheckTokenResponse>) -> Void)
    
    // Users
    func getCurrentUser(nameCase: VKService.NameCases, completionHandler: @escaping(DataResponse<VKUserModel>) -> Void)
    func getUsers(userIds: [Int], nameCase: VKService.NameCases, completionHandler: @escaping(DataResponse<[VKUserModel]>) -> Void)
    
    // News
    func getNewsFeed(types: [VKService.NewsTypes]?, count: Int?, completionHandler: @escaping (DataResponse<VKNewsFeedModel>) -> Void)
    func postWall(message: String?, place: CLLocationCoordinate2D?, completionHandler: @escaping(DataResponse<VKPostWallResponse>) -> Void)
    func addLike(type: VKService.LikeTypes, itemId: Int, authorId: Int, completionHandler: @escaping(DataResponse<VKLikeResponse>) -> Void)
    func deleteLike(type: VKService.LikeTypes, itemId: Int, authorId: Int, completionHandler: @escaping(DataResponse<VKLikeResponse>) -> Void)
    
    // Messages
    func getConversions(offset: Int?, count: Int?, filters: [VKService.ConversionFilters]?, extended: Bool, startMessageId: Int?, groupId: Int?, completionHandler: @escaping(DataResponse<[VKConversationModel]>) -> Void)
    func sendMessage(dialogId: Int, messageText text: String, completionHandler: @escaping(DataResponse<VKServiceStatusModel>) -> Void)
    
    // Friends
    func getFriends(userId: Int?, order: VKService.SortOrders?, count: Int?, offset: Int?, nameCase: VKService.NameCases, completionHandler: @escaping (DataResponse<[VKUserModel]>) -> Void)
    func getOwnerPhotos(ownerId: Int?, completionHandler: @escaping(DataResponse<[VKPhotoModel]>) -> Void)
    
    // Groups
    func getGroups(userId: Int?, extended: Bool, filters: [VKService.GroupFilters]?, offset: Int?, count: Int?, completionHandler: @escaping (DataResponse<[VKGroupModel]>) -> Void)
    func searchGroups(searchText q: String, offset: Int?, count: Int?, completionHandler: @escaping (DataResponse<[VKGroupModel]>) -> Void)
    func joinGroup(groupId: Int, completionHandler: @escaping (DataResponse<Int>) -> Void)
    func leaveGroup(groupId: Int, completionHandler: @escaping (DataResponse<Int>) -> Void)
    
}
