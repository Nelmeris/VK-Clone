//
//  VKServiceMethods.swift
//  VK Community
//
//  Created by Артем Куфаев on 13/06/2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import Foundation

extension VKService {
    class methods {
        
        static func getFriends(completion: @escaping([VKUserModel]) -> Void) {
            let code = "var friends = API.friends.get({\"fields\" : \"id,photo_100,online\", \"order\" : \"hints\"}); friends.photos = []; var i = 0; while(friends.items[i] != null) { friends.photos.push(API.photos.getAll({\"owner_id\" : friends.items[i].id})); i = i + 1;};return friends;"
            
            VKService.request(method: "execute", parameters: ["code" : code]) { (response: VKUsersResponseModel) in
                var friends = response.items
                
                for friend in friends.enumerated() {
                    FriendPhotosUIViewController.deleteOldPhotos(user: friends[friend.offset], newPhotos: response.photos[friend.offset])
                    
                    FriendPhotosUIViewController.addNewPhotos(user: friends[friend.offset], newPhotos: response.photos[friend.offset])
                }
                
                completion(friends)
            }
        }
        
        static func getGroups(completion: @escaping([VKGroupModel]) -> Void) {
            VKService.request(method: "groups.get", parameters: ["extended" : "1"]) { (response: VKItemsModel<VKGroupModel>) in
                completion(response.items)
            }
        }
        
        static func getDialogs(completion: @escaping([VKDialogModel]) -> Void) {
            VKService.request(method: "execute", parameters: ["code" : "var dialogs = API.messages.getDialogs({\"count\" : \"50\"});var i = 0; var profiles = \"\"; var groups = \"\"; while(dialogs.items[i] != null) { if(dialogs.items[i].message.user_id > 0) { profiles = profiles + dialogs.items[i].message.user_id + \",\"; } else { groups = groups + -dialogs.items[i].message.user_id + \",\"; } i = i + 1; }; dialogs.profiles = API.users.get({\"user_ids\" : profiles, \"fields\" : \"photo_100,online\"}); dialogs.groups = API.groups.getById({\"group_ids\" : groups, \"fields\" : \"photo_100\"}); return dialogs;"]) { (response: VKDialogResponseModel) in
                let dialogs = response.items
                for dialog in dialogs {
                    if dialog.type == "profile" {
                        let profile = response.profiles.filter({ (user) -> Bool in
                            return user.id == dialog.message.userId
                        })[0]
                        
                        dialog.photo100 = profile.photo100
                        dialog.title = profile.firstName + " " + profile.lastName
                        dialog.isOnline = profile.isOnline
                        dialog.isOnlineMobile = profile.isOnlineMobile
                    }
                    
                    if dialog.type == "group" {
                        let group = response.groups.filter({ (group) -> Bool in
                            return group.id == -dialog.message.userId
                        })[0]
                        
                        dialog.photo100 = group.photo100
                        dialog.title = group.name
                    }
                }
                
                completion(dialogs)
            }
        }
        
        static func getUser(id: Int? = nil, completion: @escaping(VKUserModel) -> Void) {
            var parameters = ["fields" : "photo_100"]
            
            if id != nil {
                parameters["user_id"] = String(id!)
            }
            
            VKService.request(method: "users.get", parameters: parameters) { (response: VKItemModel<VKUserModel>) in
                completion(response.item)
            }
        }
        
    }
}
