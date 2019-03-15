//
//  VKMessageUpdateModel.swift
//  VK X
//
//  Created by Artem Kufaev on 03.06.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import SwiftyJSON
import RealmSwift

class VKMessageUpdatesModel {
  var ts: Int
  var pts: Int
  var updates: [VKUpdateModel]
  
  init(_ json: JSON) {
    ts = json["ts"].intValue
    pts = json["pts"].intValue
    updates = json["updates"].map { VKUpdateModel(json: $0.1) }
  }
}

class VKBaseMessageUpdateModel {
  required convenience init(_ json: JSON) {
    self.init()
  }
}

class VKUpdateModel {
  var code = 0
  var update: VKBaseMessageUpdateModel!
  
  required convenience init(json: JSON) {
    self.init()
    
    code = json[0].intValue
    
    switch code {
    case 4:
      update = VKMessageUpdateNewMessageModel(json)
      
    case 6,7:
      update = VKMessageUpdateReadMessagesModel(json)
      
    case 8,9:
      update = VKMessageUpdateOnlineStatusChangedModel(json)
      
    default:
      break
    }
  }
}
