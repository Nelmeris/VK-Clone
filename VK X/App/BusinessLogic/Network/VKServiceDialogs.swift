//
//  VKServiceDialogs.swift
//  VK X
//
//  Created by Артем Куфаев on 02/05/2019.
//  Copyright © 2019 NONE. All rights reserved.
//

import Alamofire

extension VKService {
    
    func getDialogs(completionHandler: @escaping(DataResponse<VKDialogsModel>) -> Void) {
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
        let request = Execute(baseUrl: baseUrl, code: code)
        self.request(request: request, completionHandler: completionHandler)
    }
    
}
