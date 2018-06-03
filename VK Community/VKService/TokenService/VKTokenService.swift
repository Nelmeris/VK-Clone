//
//  VKTokenService.swift
//  VK Community
//
//  Created by Артем on 02.06.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import Keychain

class VKTokenService {
    
    static func tokenIsExist() -> Bool {
        return Keychain.load("token") != nil
    }
    
    static func tokenReceiving() {
        let storyboard = UIStoryboard(name: "VKViews", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "VKAuthorization")
        
        DispatchQueue.main.async {
            let activeViewController = getActiveViewController()!
            
            if !(activeViewController is VKAuthorizationUIViewController) {
                activeViewController.present(viewController, animated: true, completion: nil)
            }
        }
    }
    
    static func getToken() -> String? {
        guard VKTokenService.tokenIsExist() else {
            VKTokenService.tokenReceiving()
            return nil
        }
        
        return Keychain.load("token")!
    }
    
}
