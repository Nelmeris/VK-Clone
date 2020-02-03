//
//  VKServiceSecure.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 03/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Alamofire
import Keychain

protocol VKServiceSecureInterface {
    func checkToken(token: String, completionHandler: @escaping(VKCheckTokenResponse) -> Void)
}

extension VKService {
    
    private func loadSecureToken(completionHandler: @escaping(VKGetSecureTokenResponse) -> Void) {
        let request = GetSecureToken(clientId: clientId, clientSecret: clientSecret, version: apiVersion)
        self.request(request: request, completionHandler: completionHandler)
    }
    
    private func getSecureToken(completionHandler: @escaping(String) -> Void) {
        if let token = Keychain.load("secureToken") {
            completionHandler(token)
        } else {
            loadSecureToken { response in
                _ = Keychain.save(response.token, forKey: "secureToken")
                completionHandler(response.token)
            }
        }
    }
    
    func checkToken(token: String, completionHandler: @escaping(VKCheckTokenResponse) -> Void) {
        self.getSecureToken { secureToken in
            let request = CheckToken(baseUrl: self.baseUrl, version: self.apiVersion, accessToken: secureToken, token: token, clientSecret: self.clientSecret)
            self.request(request: request, completionHandler: completionHandler)
        }
    }
    
}

extension VKService {
    
    struct CheckToken: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = "secure.checkToken"
        
        let version: Double
        let accessToken: String
        let token: String
        let clientSecret: String
        
        var parameters: Parameters? {
            return [
                "v": version,
                "access_token": accessToken,
                "token": token,
                "client_secret": clientSecret
            ]
        }
    }
    
    struct GetSecureToken: RequestRouter {
        let baseUrl = URL(string: "https://oauth.vk.com/")!
        let method: HTTPMethod = .get
        let path: String = "access_token"
        
        let clientId: Int
        let clientSecret: String
        let grantType = "client_credentials"
        let version: Double
        
        var parameters: Parameters? {
            return [
                "client_id": clientId,
                "client_secret": clientSecret,
                "grant_type": grantType,
                "v": version
            ]
        }
    }
    
}
