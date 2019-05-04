//
//  VKServiceUserModel.swift
//  VK X
//
//  Created by Artem Kufaev on 09.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import RealmSwift

struct VKUsersModel: Decodable {
  var users: [VKUserModel]
  var photos: [VKPhotosModel]

  enum CodingKeys: String, CodingKey {
    case users = "items"
    case photos
  }

  init(from decoder: Decoder) throws {
    let containers = try decoder.container(keyedBy: CodingKeys.self)

    users = try containers.decode([VKUserModel].self, forKey: .users)
    photos = try containers.decode([VKPhotosModel].self, forKey: .photos)
  }
}

class VKUserModel: RealmModel {
  @objc dynamic var id = 0

  @objc dynamic var firstName = ""
  @objc dynamic var lastName = ""
  @objc dynamic var photo = ""

  @objc dynamic var isOnline = false
  @objc dynamic var isOnlineMobile: Bool = false

  var photos = List<VKPhotoModel>()

  enum CodingKeys: String, CodingKey {
    case id
    case firstName = "first_name"
    case lastName = "last_name"
    case photo = "photo_100"
    case isOnline = "online"
    case isOnlineMobile = "online_mobile"
  }

  required convenience init(from decoder: Decoder) throws {
    self.init()

    let containers = try decoder.container(keyedBy: CodingKeys.self)

    id = try containers.decode(Int.self, forKey: .id)
    firstName = try containers.decode(String.self, forKey: .firstName)
    lastName = try containers.decode(String.self, forKey: .lastName)
    photo = try containers.decode(String.self, forKey: .photo)
    isOnline = (try? containers.decode(Int.self, forKey: .isOnline) == 1) ?? false
    isOnlineMobile = (try? containers.decode(Int.self, forKey: .isOnlineMobile) == 1) ?? false

    photos = List<VKPhotoModel>()
  }

  override static func primaryKey() -> String? {
    return "id"
  }

  override func isEqual(_ object: RealmModel) -> Bool {
    guard let neewUser = object as? VKUserModel else { return false }
    return (id == neewUser.id) &&
      (firstName == neewUser.firstName) &&
      (lastName == neewUser.lastName) &&
      (photo == neewUser.photo) &&
      (isOnline == neewUser.isOnline) &&
      (isOnlineMobile == neewUser.isOnlineMobile)
  }
}

struct VKSoloUserModel: Decodable {
  var user: VKUserModel

  init(from decoder: Decoder) throws {
    let containers = try decoder.singleValueContainer()

    user = (try containers.decode([VKUserModel].self))[0]
  }
}
