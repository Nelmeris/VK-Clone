//
//  VKServiceDialogModel.swift
//  VK X
//
//  Created by Artem Kufaev on 31.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import SwiftyJSON
import RealmSwift

class VKDialogResponseModel: VKBaseModel {
  var items: [VKDialogModel] = []
  var profiles: [VKUserModel] = []
  var groups: [VKGroupModel] = []
  
  required convenience init(_ json: JSON) {
    self.init()
    
    items = json["items"].map { VKDialogModel($0.1) }
    profiles = json["profiles"].map { VKUserModel($0.1) }
    groups = json["groups"].map { VKGroupModel($0.1) }
  }
}

class VKDialogModel: RealmModel {
  @objc dynamic var id = 0
  @objc dynamic var type = ""
  @objc dynamic var title = ""
  
  @objc dynamic var message: VKMessageModel!
  
  var messages = List<VKMessageModel>()
  
  @objc dynamic var inRead = 0
  @objc dynamic var outRead = 0
  
  @objc dynamic var usersCount = 0
  @objc dynamic var photo100 = ""
  
  @objc dynamic var isOnline = false
  @objc dynamic var isOnlineMobile = false
  
  required convenience init(_ json: JSON) {
    self.init()
    
    message = VKMessageModel(json["message"])
    inRead = json["in_read"].intValue
    outRead = json["out_read"].intValue
    
    title = json["message"]["title"].stringValue
    usersCount = json["message"]["users_count"].intValue
    photo100 = json["message"]["photo_100"].stringValue
    
    if message.chatId != 0 {
      id = 2000000000 + message.chatId
      type = "chat"
    } else {
      if message.userId > 0 {
        id = message.userId
        type = "profile"
      } else {
        id = -message.userId
        type = "group"
      }
    }
  }
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  override func isEqual (_ object: RealmModel) -> Bool {
    let object = object as! VKDialogModel
    return (id == object.id) &&
      (title == object.title) &&
      (type == object.type) &&
      (photo100 == object.photo100) &&
      (isOnline == object.isOnline) &&
      (isOnlineMobile == object.isOnlineMobile) &&
      (message.date == object.message.date) &&
      (message.text == object.message.text)
  }
}
