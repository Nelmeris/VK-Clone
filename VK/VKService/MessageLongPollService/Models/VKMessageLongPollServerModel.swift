//
//  VKMessageLongPollServerModel.swift
//  VK X
//
//  Created by Artem Kufaev on 03.06.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import SwiftyJSON
import RealmSwift

class VKMessageLongPollServerModel: RealmModel {
  @objc dynamic var key = ""
  @objc dynamic var server = ""
  @objc dynamic var ts = 0
  @objc dynamic var pts = 0
  
  required convenience init(_ json: JSON) {
    self.init()
    
    key = json["key"].stringValue
    server = json["server"].stringValue
    ts = json["ts"].intValue
    pts = json["pts"].intValue
  }
}
