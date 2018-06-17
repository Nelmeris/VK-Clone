//
//  VKServiceMethods.swift
//  VK X
//
//  Created by Артем Куфаев on 13/06/2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import Foundation

extension VKService {
  func getFriends(completion: @escaping([VKUserModel]) -> Void) {
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
  
  func getGroups(completion: @escaping([VKGroupModel]) -> Void) {
    VKService.shared.request(method: "groups.get", parameters: ["extended": "1"]) { (response: VKGroupsModel) in
      completion(response.groups)
    }
  }
  
  func getDialogs(completion: @escaping([VKDialogModel]) -> Void) {
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
      let dialogs = response.dialogs
      
      completion(dialogs)
    }
  }
  
  func getUser(id: Int? = nil, completion: @escaping(VKSoloUserModel) -> Void) {
    var parameters = ["fields": "photo_100"]
    
    if let id = id {
      parameters["user_id"] = String(id)
    }
    
    VKService.shared.request(method: "users.get", parameters: parameters) { (response: VKSoloUserModel) in
      completion(response)
    }
  }
}
