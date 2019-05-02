//
//  VKMessageUpdateFlagsModel.swift
//  VK X
//
//  Created by Artem Kufaev on 05.06.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import SwiftyJSON

class VKMessageUpdateFlagsModel: VKBaseMessageUpdateModel {
  var isOut = false

  required convenience init(_ json: JSON) {
    self.init()
  }

  required convenience init(_ flags: Int) {
    self.init()

    isOut = flags & 2 == 2
  }
}
