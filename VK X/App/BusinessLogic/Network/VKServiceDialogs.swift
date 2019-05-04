//
//  VKServiceDialogs.swift
//  VK X
//
//  Created by Артем Куфаев on 02/05/2019.
//  Copyright © 2019 NONE. All rights reserved.
//

import Alamofire

extension VKService {
    
    func getDialogs(completionHandler: @escaping(DataResponse<[VKDialogModel]>) -> Void) {
        let code = """
          var dialogs = API.messages.getDialogs({"count": "50"});
          return dialogs;
        """
        VKTokenService.shared.getToken { token in
            let request = Execute(baseUrl: self.baseUrl, version: self.apiVersion, token: token, code: code)
            self.request(request: request, completionHandler: completionHandler)
        }
    }
    
}
