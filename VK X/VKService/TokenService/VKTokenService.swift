//
//  VKTokenService.swift
//  VK X
//
//  Created by Artem Kufaev on 02.06.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit
import Keychain

class VKTokenService {
  private init() {}
  
  static let shared = VKTokenService()
  
  func tokenIsExist() -> Bool {
    return Keychain.load("token") != nil
  }
  
  func tokenReceiving() {
    let storyboard = UIStoryboard(name: "VKViews", bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: "VKAuthorization")
    
    while getActiveViewController() == nil { continue }
    let activeViewController = getActiveViewController()!
    
    guard !(activeViewController is VKAuthorizationUIViewController) else { return }
    activeViewController.present(viewController, animated: true)
  }
  
  let dispatchGroup = DispatchGroup()
  
  @objc func getToken(completion: @escaping (String) -> Void = {_ in}) {
    guard tokenIsExist() else {
      DispatchQueue.main.async {
        self.tokenReceiving()
      }
      NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "tokenReceived"), object: nil, queue: nil) { (not) in
        completion(Keychain.load("token")!)
      }
      return
    }
    
    completion(Keychain.load("token")!)
  }
}
