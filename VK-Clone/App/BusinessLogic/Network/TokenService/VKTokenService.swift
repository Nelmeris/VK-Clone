//
//  VKTokenService.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 02.06.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit
import Keychain

struct VKToken {
    let value: String
    let dateExpires: Date
}

class VKTokenService {
    
    private init() {}
    static let shared = VKTokenService()
    
    let tokenKey = "access_token"
    let tokenExpiresTimeKey = "expires_time"
    let notificationKey = "tokenReceived"
    
    func load() -> VKToken? {
        guard let tokenValue = Keychain.load(tokenKey),
            let tokenExpiresTimeIntervalString = Keychain.load(tokenExpiresTimeKey),
            let tokenExpiresTimeInterval = TimeInterval(tokenExpiresTimeIntervalString) else { return nil }
        return VKToken(value: tokenValue, dateExpires: Date(timeIntervalSince1970: tokenExpiresTimeInterval))
    }
    
    func delete() {
        _ = Keychain.delete(tokenKey)
        _ = Keychain.delete(tokenExpiresTimeKey)
    }
    
    private func receiving(completion: @escaping (VKToken) -> Void) {
        DispatchQueue.main.async {
            let viewController = VKAuthorizationViewController()
            
            while getVisibleViewController() == nil { continue }
            let visibleViewController = getVisibleViewController()!
            
            guard !(visibleViewController is VKAuthorizationViewController) else { return }
            visibleViewController.present(viewController, animated: true)
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: self.notificationKey), object: nil, queue: nil) { notification in
                completion(notification.object as! VKToken)
            }
        }
    }
    
    func get(completion: @escaping (VKToken) -> Void = {_ in}) {
        guard let token = load(),
            token.dateExpires > Date() else {
            self.receiving() { token in
                completion(token)
            }
            return
        }
        completion(token)
    }
    
}
