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
    DispatchQueue.main.async {
      let storyboard = UIStoryboard(name: "VKViews", bundle: nil)
      let viewController = storyboard.instantiateViewController(withIdentifier: "VKAuthorization")
      
      while getVisibleViewController() == nil { continue }
      let visibleViewController = getVisibleViewController()!
      
      guard !(visibleViewController is VKAuthorizationUIViewController) else { return }
      visibleViewController.present(viewController, animated: true)
    }
  }
  
  func tokenDelete() {
    _ = Keychain.delete("token")
  }
  
  let dispatchGroup = DispatchGroup()
  
  @objc func getToken(completion: @escaping (String) -> Void = {_ in}) {
    guard tokenIsExist() else {
      self.tokenReceiving()
      NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "tokenReceived"), object: nil, queue: nil) { _ in
        completion(Keychain.load("token")!)
      }
      return
    }
    
    completion(Keychain.load("token")!)
  }
}
