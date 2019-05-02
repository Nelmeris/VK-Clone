//
//  VKMessageUpdateOnlineStatusChangedModel.swift
//  VK X
//
//  Created by Artem Kufaev on 04.06.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import SwiftyJSON

class VKMessageUpdateOnlineStatusChangedModel: VKBaseMessageUpdateModel {
  var userId = 0

  required convenience init(_ json: JSON) {
    self.init()

    userId = json[1].intValue
  }
}
