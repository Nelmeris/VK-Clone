//
//  VKServiceMessageModel.swift
//  VK X
//
//  Created by Artem Kufaev on 31.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import RealmSwift

struct VKMessagesModel: Decodable {
  var count: Int

  var messages: [VKMessageModel]

  /// ID последнего прочитанного сообщения собеседником
  var inRead: Int

  /// ID последнего прочитанного сообщения пользователем
  var outRead: Int

  enum CodingKeys: String, CodingKey {
    case count
    case messages = "items"
    case inRead = "in_read"
    case outRead = "out_read"
  }

  init(from decoder: Decoder) throws {
    let containers = try decoder.container(keyedBy: CodingKeys.self)

    count = try containers.decode(Int.self, forKey: .count)
    messages = try containers.decode([VKMessageModel].self, forKey: .messages)
    inRead = try containers.decode(Int.self, forKey: .inRead)
    outRead = try containers.decode(Int.self, forKey: .outRead)
  }
}

class VKMessageModel: RealmModel {
  @objc dynamic var id = 0
  @objc dynamic var date = Date()
  @objc dynamic var text = ""
  /// ID отправителя
  @objc dynamic var fromId = 0

  /// Тип сообщения (отправленное/полученное)
  @objc dynamic var isOut = false

  /// Статус прочтения сообщения
  @objc dynamic var isRead = false

  enum CodingKeys: String, CodingKey {
    case id
    case date
    case text = "body"
    case fromId = "from_id"
    case userId = "user_id"
    case isOut = "out"
    case isRead = "read_state"
  }

  required convenience init(from decoder: Decoder) throws {
    self.init()

    let containers = try decoder.container(keyedBy: CodingKeys.self)

    id = try containers.decode(Int.self, forKey: .id)
    let date = try containers.decode(Int.self, forKey: .date)
    self.date = Date(timeIntervalSince1970: Double(date))
    text = try containers.decode(String.self, forKey: .text)
    isOut = try containers.decode(Int.self, forKey: .isOut) == 1
    isRead = try containers.decode(Int.self, forKey: .isRead) == 1

    if let fromId = try? containers.decode(Int.self, forKey: .fromId) {
      self.fromId = fromId
    } else {
      if isOut {
        fromId = VKService.shared.user.id
      } else {
        let userId = try containers.decode(Int.self, forKey: .userId)
        fromId = userId
      }
    }
  }

  convenience init(id: Int, text: String, fromId: Int, date: Date, isOut: Bool, isRead: Bool) {
    self.init()

    self.id = id
    self.text = text
    self.fromId = fromId
    self.date = date
    self.isOut = isOut
    self.isRead = isRead
  }

  override func isEqual(_ object: RealmModel) -> Bool {
    let object = object as! VKMessageModel
    return (id == object.id) &&
      (date == object.date) &&
      (fromId == object.fromId) &&
      (text == object.text) &&
      (isOut == object.isOut) &&
      (isRead == object.isRead)
  }
}
