//
//  VKMessageUpdateReadMessagesModel.swift
//  VK X
//
//  Created by Artem Kufaev on 03.06.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import SwiftyJSON

class VKMessageUpdateReadMessagesModel: VKBaseMessageUpdateModel {
  var peerId = 0
  var localId = 0

  required convenience init(_ json: JSON) {
    self.init()

    peerId = json[1].intValue
    localId = json[2].intValue
  }
}
