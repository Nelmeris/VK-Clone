//
//  VKServiceMessageModel.swift
//  VK X
//
//  Created by Artem Kufaev on 31.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import SwiftyJSON
import RealmSwift

class VKMessageResponseModel: VKBaseModel {
  var count = 0
  var items: [VKMessageModel] = []
  var inRead = 0
  var outRead = 0
  
  required convenience init(_ json: JSON) {
    self.init()
    
    count = json["count"].intValue
    items = json["items"].map { VKMessageModel($0.1) }
    inRead = json["in_read"].intValue
    outRead = json["out_read"].intValue
  }
}

class VKMessageModel: RealmModel {
  @objc dynamic var id = 0
  @objc dynamic var date = Date()
  @objc dynamic var isOut = false
  @objc dynamic var userId = 0
  @objc dynamic var isRead = false
  @objc dynamic var text = ""
  @objc dynamic var chatId = 0
  @objc dynamic var fromId = 0
  
  var chatActive = List<Int>()
  
  required convenience init(_ json: JSON) {
    self.init()
    
    id = json["id"].intValue
    date = Date(timeIntervalSince1970: Double(json["date"].intValue))
    isOut = json["out"].intValue == 1
    userId = json["user_id"].intValue
    isRead = json["read_state"].intValue == 1
    text = json["body"].stringValue
    chatId = json["chat_id"].intValue
    fromId = json["from_id"].intValue
    
    guard let intArray = json["chat_active"].arrayObject as? [Int] else { return }
    
    chatActive.append(objectsIn: intArray)
  }
  
  convenience init(id: Int, text: String, fromId: Int, date: Date, isOut: Bool) {
    self.init()
    
    self.id = id
    self.text = text
    self.date = date
    self.isOut = isOut
  }
  
  override func isEqual(_ object: RealmModel) -> Bool {
    let object = object as! VKMessageModel
    return (id == object.id) &&
      (date == object.date) &&
      (userId == object.userId) &&
      (text == object.text) &&
      (isOut == object.isOut)
  }
}
