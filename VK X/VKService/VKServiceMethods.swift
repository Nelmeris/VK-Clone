//
//  VKServiceMethods.swift
//  VK X
//
//  Created by Артем Куфаев on 13/06/2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import Foundation
import MapKit

extension VKService {
  
  class Methods {
    
    
    class NewsFeed {
      enum newsTypes: String {
        case post
      }
      
      class func get(type: newsTypes, count: Int = 50, completion: @escaping(VKNewsFeedModel) -> Void) {
        VKService.shared.request(method: "newsfeed.get", parameters: ["filters": type.rawValue, "count": String(count)]) { (response: VKNewsFeedModel) in
          completion(response)
        }
      }
    }
    
    
    
    class Friends {
      class func get(completion: @escaping([VKUserModel]) -> Void) {
        let code = """
        {
          var friends = API.friends.get({"fields": "id,photo_100,online", "order": "hints"});
          friends.photos = [];
          var i = 0;

          while(friends.items[i] != null) {
            friends.photos.push(API.photos.getAll({"owner_id": friends.items[i].id}));
            i = i + 1;
          };

          return friends;
        }
        """
        
        VKService.shared.request(method: "execute", parameters: ["code": code]) { (response: VKUsersModel) in
          let friends = response.users
          
          completion(friends)
        }
      }
    }
    
    
    
    class Groups {
      class func get(completion: @escaping([VKGroupModel]) -> Void) {
        VKService.shared.request(method: "groups.get", parameters: ["extended": "1"]) { (response: VKGroupsModel) in
          completion(response.groups)
        }
      }
      
      class func leave(groupId id: Int, completion: @escaping() -> Void = {}) {
        VKService.shared.irrevocableRequest(method: "groups.leave", parameters: ["group_id": String(id)]) {
          completion()
        }
      }
      
      class func join(groupId id: Int, completion: @escaping() -> Void = {}) {
        VKService.shared.irrevocableRequest(method: "groups.join", parameters: ["group_id": String(id)]) {
          completion()
        }
      }
      
      class func search(searchText q: String, completion: @escaping([VKGroupModel]) -> Void) {
        VKService.shared.request(method: "groups.search", parameters: ["fields": "members_count", "sort": "0", "q": q]) { (response: VKGroupsModel) in
          completion(response.groups)
        }
      }
    }
    
    
    
    class Messages {
      class func get(dialogId: Int, count: Int = 20, completion: @escaping(VKMessagesModel) -> Void) {
        VKService.shared.request(method: "messages.getHistory", parameters: ["peer_id": String(dialogId), "count": String(count)]) { (response: VKMessagesModel) in
          completion(response)
        }
      }
      
      class func send(dialogId: Int, messageText text: String) {
        VKService.shared.irrevocableRequest(method: "messages.send", parameters: ["peer_id": String(dialogId), "message": text])
      }
    }
    
    
    
    class Dialogs {
      class func get(completion: @escaping([VKDialogModel]) -> Void) {
        let code = """
        {
          var dialogs = API.messages.getDialogs({"count": "50"});

          var i = 0;
          var profiles = "";
          var groups = "";

          while(dialogs.items[i] != null) {

            if(dialogs.items[i].message.user_id > 0) {
              profiles = profiles + dialogs.items[i].message.user_id + ",";
            } else {
              groups = groups + -dialogs.items[i].message.user_id + ",";
            }
            i = i + 1;

          };

          dialogs.profiles = API.users.get({"user_ids": profiles, "fields": "photo_100,online"});
          dialogs.groups = API.groups.getById({"group_ids": groups, "fields": "photo_100"});

        return dialogs;
        }
        """
        
        VKService.shared.request(method: "execute", parameters: ["code": code]) { (response: VKDialogsModel) in
          completion(response.dialogs)
        }
      }
    }
    
    
    
    class Users {
      class func get(id: Int? = nil, completion: @escaping(VKUserModel) -> Void) {
        var parameters = ["fields": "photo_100"]
        
        if let id = id {
          parameters["user_id"] = String(id)
        }
        
        VKService.shared.request(method: "users.get", parameters: parameters) { (response: VKSoloUserModel) in
          completion(response.user)
        }
      }
    }
    
    
    class Wall {
      class func post(text: String?, place: CLLocationCoordinate2D?) {
        var params = [String: String]()
        if text != nil {
          params["text"] = text
        }
        if place != nil {
          params["lat"] = String(place!.latitude)
          params["lon"] = String(place!.longitude)
        }
        VKService.shared.irrevocableRequest(method: "wall.post", parameters: params)
      }
    }
    
    
    class Likes {
      enum likeTypes: String {
        case post
      }
      
      enum likeActions: String {
        case add, delete
      }
      
      class func action(action: likeActions, type: likeTypes, itemId: Int, authorId: Int) {
        let parameters = [
          "type": type.rawValue,
          "item_id": String(itemId),
          "owner_id": String(authorId)
        ]
        VKService.shared.irrevocableRequest(method: "likes." + action.rawValue, parameters: parameters)
      }
    }
    
    
    
    class Photos {
      class func getAll(ownerId: Int, completion: @escaping([VKPhotoModel]) -> Void) {
        VKService.shared.request(method: "photos.getAll", parameters: ["owner_id": String(ownerId)]) { (response: VKPhotosModel) in
          completion(response.photos)
        }
      }
    }
    
    
  }
  
}
