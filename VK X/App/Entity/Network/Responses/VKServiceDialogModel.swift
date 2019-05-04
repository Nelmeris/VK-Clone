//
//  VKServiceDialogModel.swift
//  VK X
//
//  Created by Artem Kufaev on 31.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import RealmSwift

struct VKDialogsModel: Decodable {
  var dialogs: [VKDialogModel]
  var profiles: [VKUserModel]
  var groups: [VKGroupModel]

  enum CodingKeys: String, CodingKey {
    case dialogs = "items"
    case profiles
    case groups
  }

  init(from decoder: Decoder) throws {
    let containers = try decoder.container(keyedBy: CodingKeys.self)

    dialogs = try containers.decode([VKDialogModel].self, forKey: .dialogs)
    profiles = try containers.decode([VKUserModel].self, forKey: .profiles)
    groups = try containers.decode([VKGroupModel].self, forKey: .groups)

    for dialog in dialogs {
      switch dialog.type {
      case "profile":
        let profile = profiles.filter { user -> Bool in
          user.id == dialog.id
          }.first!

        dialog.photo = profile.photo
        dialog.title = profile.firstName + " " + profile.lastName
        dialog.isOnline = profile.isOnline
        dialog.isOnlineMobile = profile.isOnlineMobile
      case "group":
        let group = groups.filter { group -> Bool in
          group.id == -dialog.id
          }.first!

        dialog.photo = group.photo
        dialog.title = group.name
      default: break
      }
    }
  }
}

class VKDialogModel: RealmModel {
  @objc dynamic var id = 0

  @objc dynamic var message: VKMessageModel!
  @objc dynamic var inRead = 0
  @objc dynamic var outRead = 0

  @objc dynamic var title = ""
  @objc dynamic var photo = ""
  @objc dynamic var type = ""

  @objc dynamic var isOnline = false
  @objc dynamic var isOnlineMobile = false

  var messages = List<VKMessageModel>()

  enum CodingKeys: String, CodingKey {
    case message
    case inRead = "in_read"
    case outRead = "out_read"
  }

  required convenience init(from decoder: Decoder) throws {
    self.init()

    let containers = try decoder.container(keyedBy: CodingKeys.self)

    message = try containers.decode(VKMessageModel.self, forKey: .message)
    let dialogMessage = try containers.decode(VKDialogMessageInfoModel.self, forKey: .message)
    inRead = try containers.decode(Int.self, forKey: .inRead)
    outRead = try containers.decode(Int.self, forKey: .outRead)

    title = dialogMessage.title
    photo = dialogMessage.photo

    if dialogMessage.chatId != 0 {
      id = dialogMessage.chatId + 2_000_000_000
      type = "chat"
    } else {
      let isProfile = dialogMessage.userId > 0
      id = dialogMessage.userId
      type = (isProfile ? "profile" : "group")
    }
  }

  override static func primaryKey() -> String? {
    return "id"
  }

  override func isEqual (_ object: RealmModel) -> Bool {
    guard let newDialog = object as? VKDialogModel else { return false }
    return (id == newDialog.id) &&
      (message.isEqual(newDialog.message)) &&
      (title == newDialog.title) &&
      (photo == newDialog.photo) &&
      (isOnline == newDialog.isOnline) &&
      (isOnlineMobile == newDialog.isOnlineMobile)
  }
}

class VKDialogMessageInfoModel: Decodable {
  var title = ""
  var photo = ""
  var chatId = 0
  var userId = 0

  enum CodingKeys: String, CodingKey {
    case title = "title"
    case photo = "photo_100"

    case chatId = "chat_id"
    case userId = "user_id"
  }

  required convenience init(from decoder: Decoder) throws {
    self.init()

    let containers = try decoder.container(keyedBy: CodingKeys.self)

    title = (try? containers.decode(String.self, forKey: .title)) ?? ""
    photo = (try? containers.decode(String.self, forKey: .photo)) ?? ""
    chatId = (try? containers.decode(Int.self, forKey: .chatId)) ?? 0
    userId = (try? containers.decode(Int.self, forKey: .userId)) ?? 0
  }
}
