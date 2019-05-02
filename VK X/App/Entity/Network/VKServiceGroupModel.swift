//
//  VKServiceGroupModel.swift
//  VK X
//
//  Created by Artem Kufaev on 10.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import RealmSwift

struct VKGroupsModel: Decodable {
  var groups: [VKGroupModel]

  enum CodingKeys: String, CodingKey {
    case groups = "items"
  }

  init(from decoder: Decoder) throws {
    let containers = try decoder.container(keyedBy: CodingKeys.self)

    groups = try containers.decode([VKGroupModel].self, forKey: .groups)
  }
}

class VKGroupModel: RealmModel {
  @objc dynamic var id = 0

  @objc dynamic var name = ""
  @objc dynamic var photo = ""

  /// Количество участников
  @objc dynamic var membersCount = 0

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case photo = "photo_100"
    case membersCount = "members_count"
  }

  required convenience init(from decoder: Decoder) throws {
    self.init()

    let containers = try decoder.container(keyedBy: CodingKeys.self)

    id = try containers.decode (Int.self, forKey: .id)
    name = try containers.decode (String.self, forKey: .name)
    photo = try containers.decode (String.self, forKey: .photo)
    membersCount = (try? containers.decode (Int.self, forKey: .membersCount)) ?? 0
  }

  override static func primaryKey() -> String? {
    return "id"
  }

  override func isEqual (_ object: RealmModel) -> Bool {
    guard let newGroup = object as? VKGroupModel else { return false }
    return (id == newGroup.id) &&
      (name == newGroup.name) &&
      (photo == newGroup.photo) &&
      (membersCount == newGroup.membersCount)
  }
}
