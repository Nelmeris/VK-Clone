//
//  VKServiceSizes.swift
//  VK X
//
//  Created by Artem Kufaev on 31.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import RealmSwift

class VKSizeModel: RealmModel {
  @objc dynamic var type = ""
  @objc dynamic var url = ""

  @objc dynamic var width = 0
  @objc dynamic var height = 0

  enum CodingKeys: String, CodingKey {
    case type, url
    case width, height
  }

  required convenience init(from decoder: Decoder) throws {
    self.init()

    let containers = try decoder.container(keyedBy: CodingKeys.self)

    type = try containers.decode(String.self, forKey: .type)
    url = try containers.decode(String.self, forKey: .url)
    width = try containers.decode(Int.self, forKey: .width)
    height = try containers.decode(Int.self, forKey: .height)
  }

  override func isEqual(_ object: RealmModel) -> Bool {
    guard let newSize = object as? VKSizeModel else {
      return false
    }

    return (type == newSize.type) &&
      (url == newSize.url) &&
      (width == newSize.width) &&
      (height == newSize.height)
  }
}
