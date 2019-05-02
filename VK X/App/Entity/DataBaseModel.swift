//
//  DataBaseModel.swift
//  VK X
//
//  Created by Artem Kufaev on 20.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import SwiftyJSON
import RealmSwift

class RealmModel: Object, Decodable {
  func isEqual (_ object: RealmModel) -> Bool {
    return false
  }
}
