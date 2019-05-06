//
//  VKTokenService.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 02.06.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit
import Keychain

class VKTokenService {
    private init() {}
    static let shared = VKTokenService()
    
    let key = "access_token"
    let notificationKey = "tokenReceived"
    
    func load() -> String? {
        return Keychain.load(key)
    }
    
    func delete() {
        _ = Keychain.delete(key)
    }
    
    private func receiving(completion: @escaping (String) -> Void) {
        DispatchQueue.main.async {
            let viewController = VKAuthorizationViewController()
            
            while getVisibleViewController() == nil { continue }
            let visibleViewController = getVisibleViewController()!
            
            guard !(visibleViewController is VKAuthorizationViewController) else { return }
            visibleViewController.present(viewController, animated: true)
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: self.notificationKey), object: nil, queue: nil) { _ in
                completion(Keychain.load(self.key)!)
            }
        }
    }
    
    func get(completion: @escaping (String) -> Void = {_ in}) {
        guard let token = load() else {
            self.receiving() { token in
                completion(token)
            }
            return
        }
        
        VKService.shared.checkToken(token: token) { response in
            guard response.value != nil else {
                self.receiving() { token in
                    completion(token)
                }
                return
            }
            
            completion(token)
        }
    }
}
