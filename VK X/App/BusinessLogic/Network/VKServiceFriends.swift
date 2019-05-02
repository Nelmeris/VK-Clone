//
//  VKServiceFriends.swift
//  VK X
//
//  Created by Артем Куфаев on 02/05/2019.
//  Copyright © 2019 NONE. All rights reserved.
//

import Alamofire

extension VKService {
    
    func getFriends(completionHandler: @escaping (DataResponse<VKUsersModel>) -> Void) {
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
        let request = Execute(baseUrl: baseUrl, code: code)
        self.request(request: request, completionHandler: completionHandler)
    }
    
}
