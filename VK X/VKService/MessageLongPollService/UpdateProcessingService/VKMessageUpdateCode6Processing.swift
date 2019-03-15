//
//  VKMessageUpdateCode6Processing.swift
//  VK X
//
//  Created by Artem Kufaev on 03.06.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit
import RealmSwift

extension VKLongPollOperation {
  func Code6Processing(_ update: VKUpdateModel) {
    let readMessages = update.update as! VKMessageUpdateReadMessagesModel
    
    DispatchQueue.main.async {
      let dialogs: Results<VKDialogModel> = RealmService.shared.loadData()!
      
      guard let dialog = dialogs.filter("id = \(readMessages.peerId)").first else {
        // Обработать новый диалог
        return
      }
      
      do {
        let realm = try Realm()
        realm.beginWrite()
        for message in dialog.messages {
          message.isRead = dialog.inRead...readMessages.localId ~= message.id
        }
        dialog.inRead = readMessages.localId
        try realm.commitWrite()
      } catch let error {
        print(error)
      }
    }
  }
}
