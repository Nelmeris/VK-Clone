//
//  UsersGet.swift
//  VK X
//
//  Created by Артем Куфаев on 16/06/2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit

class UsersGet: Operation {
  var response: [VKUserModel] = []
  
  enum State: String {
    case ready, executing, fitished
    fileprivate var keyPath: String {
      return "is" + rawValue.capitalized
    }
  }
  
  private var state = State.ready {
    willSet {
      willChangeValue(forKey: state.keyPath)
      willChangeValue(forKey: newValue.keyPath)
    }
    didSet {
      didChangeValue(forKey: state.keyPath)
      didChangeValue(forKey: oldValue.keyPath)
    }
  }
  
  override var isAsynchronous: Bool {
    return true
  }
  
  override var isReady: Bool {
    return super.isReady && state == .ready
  }
  
  override var isExecuting: Bool {
    return state == .executing
  }
  
  override var isFinished: Bool {
    return state == .fitished
  }
  
  override func start() {
    if isCancelled {
      state = .fitished
    } else {
      main()
      state = .executing
    }
  }
  
  override func cancel() {
    super.cancel()
  }
  
  private let code = "var friends = API.friends.get({\"fields\": \"id,photo_100,online\", \"order\": \"hints\"}); friends.photos = []; var i = 0; while(friends.items[i] != null) { friends.photos.push(API.photos.getAll({\"owner_id\": friends.items[i].id})); i = i + 1;};return friends;"
  
  override func main() {
    let code = "var friends = API.friends.get({\"fields\": \"id,photo_100,online\", \"order\": \"hints\"}); friends.photos = []; var i = 0; while(friends.items[i] != null) { friends.photos.push(API.photos.getAll({\"owner_id\": friends.items[i].id})); i = i + 1;};return friends;"
    
    VKService.shared.request(method: "execute", parameters: ["code": code]) { [weak self] (response: VKUsersResponseModel) in
      let friends = response.items
      
      for (index, friend) in friends.enumerated() {
        FriendPhotosUIViewController.deleteOldPhotos(user: friend, newPhotos: response.photos[index])
        FriendPhotosUIViewController.addNewPhotos(user: friend, newPhotos: response.photos[index])
      }
      
      self?.response = friends
      
    }
  }
}
