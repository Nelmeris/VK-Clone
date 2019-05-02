//
//  VKMessageUpdateCode4Processing.swift
//  VK X
//
//  Created by Artem Kufaev on 03.06.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit
import RealmSwift

extension VKLongPollOperation {
  func Code4Processing(_ update: VKUpdateModel) {
    let newMessage = update.update as! VKMessageUpdateNewMessageModel

    DispatchQueue.main.async {
      let dialogs: Results<VKDialogModel> = RealmService.shared.loadData()!

      let dialog = dialogs.filter("id = \(newMessage.peerId)").first!

      do {
        let realm = try Realm()
        realm.beginWrite()

        let newMessage = VKMessageModel(id: newMessage.id,
                                     text: newMessage.text,
                                     fromId: (newMessage.flags.isOut ? VKService.shared.user.id : newMessage.peerId),
                                     date: newMessage.date,
                                     isOut: newMessage.flags.isOut,
                                     isRead: false)

        dialog.message = newMessage
        dialog.messages.insert(newMessage, at: 0)

        try realm.commitWrite()
      } catch {
        print(error)
      }
    }
  }
}
