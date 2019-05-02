//
//  VKMessageUpdateNewMessageModel.swift
//  VK X
//
//  Created by Artem Kufaev on 03.06.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import SwiftyJSON

class VKMessageUpdateNewMessageModel: VKBaseMessageUpdateModel {
  var id = 0
  var flags: VKMessageUpdateFlagsModel!
  var peerId = 0
  var date = Date()
  var text = ""

  required convenience init(_ json: JSON) {
    self.init()

    id = json[1].intValue
    flags = VKMessageUpdateFlagsModel(json[2].intValue)
    peerId = json[3].intValue
    date = Date(timeIntervalSince1970: Double(json[4].intValue))
    text = json[5].stringValue
  }
}
