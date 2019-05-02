//
//  VKMessageLongPollServerModel.swift
//  VK X
//
//  Created by Artem Kufaev on 03.06.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import RealmSwift

class VKMessageLongPollServerModel: RealmModel {
  @objc dynamic var key = ""
  @objc dynamic var server = ""
  @objc dynamic var ts = 0
  @objc dynamic var pts = 0

  enum CodingKeys: String, CodingKey {
    case key
    case server
    case ts
    case pts
  }

  required convenience init(from decoder: Decoder) throws {
    self.init()
    let containers = try decoder.container(keyedBy: CodingKeys.self)

    key = try containers.decode(String.self, forKey: .key)
    server = try containers.decode(String.self, forKey: .server)
    ts = try containers.decode(Int.self, forKey: .ts)
    pts = (try? containers.decode(Int.self, forKey: .pts)) ?? 0
  }
}
