//
//  VKMessageUpdateCode7Processing.swift
//  VK X
//
//  Created by Artem Kufaev on 03.06.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit
import RealmSwift

extension VKMessageLongPollService {
  func Code7DialogProcessing(_ controller: DialogsUITableViewController,_ update: VKUpdateModel) {
    let readMessages = update.update as! VKMessageUpdateReadMessagesModel
    
    DispatchQueue.main.async {
      let dialogs: Results<VKDialogModel> = RealmService.loadData()!
      
      let dialog = dialogs.filter("id = \(readMessages.peerId)").first!
      
      do {
        let realm = try Realm()
        realm.beginWrite()
        dialog.message.isRead = true
        try realm.commitWrite()
      } catch let error {
        print(error)
      }
    }
  }
  
  
  func Code7MessageProcessing(_ controller: MessagesUIViewController, _ update: VKUpdateModel) {
    let readMessages = update.update as! VKMessageUpdateReadMessagesModel
    guard readMessages.peerId == controller.dialogId else { return }
    
    DispatchQueue.main.async {
      do {
        let realm = try Realm()
        realm.beginWrite()
        for message in controller.dialog.messages {
          message.isRead = controller.dialog.outRead...readMessages.localId ~= message.id
        }
        controller.dialog.outRead = readMessages.localId
        try realm.commitWrite()
      } catch let error {
        print(error)
      }
    }
  }
}
