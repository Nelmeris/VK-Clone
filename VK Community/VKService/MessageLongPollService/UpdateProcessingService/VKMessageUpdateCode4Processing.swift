//
//  VKMessageUpdateCode4Processing.swift
//  VK Community
//
//  Created by Артем on 03.06.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import RealmSwift

extension VKMessageLongPollService {
    
    static func Code4DialogProcessing(_ controller: DialogsUITableViewController, _ update: VKMessageUpdatesModel.Update) {
        
        let newMessage = update.update as! VKMessageUpdateNewMessageModel
        
        DispatchQueue.main.async {
            let dialogs: Results<VKDialogModel> = RealmService.loadData()!
            
            let dialog = dialogs.filter("id = \(newMessage.peerId)")[0]
            
            do {
                let realm = try Realm()
                realm.beginWrite()
                
                dialog.message.id = newMessage.id
                dialog.message.text = newMessage.text
                dialog.message.isOut = newMessage.flags.isOut
                dialog.message.date = newMessage.date
                dialog.message.userId = 0
                
                try realm.commitWrite()
            } catch let error {
                print(error)
            }
        }
        
    }
    
    static func Code4MessageProcessing(_ controller: MessagesUIViewController, _ update: VKMessageUpdatesModel.Update) {
        
        let newMessage = update.update as! VKMessageUpdateNewMessageModel
        
        guard newMessage.peerId == controller.dialogId else { return }
        
        DispatchQueue.main.async {
            do {
                let realm = try Realm()
                realm.beginWrite()
                controller.dialog.messages.insert(VKMessageModel(id: newMessage.id,
                                                                 text: newMessage.text,
                                                                 fromId: newMessage.flags.isOut ? VKService.shared.user.id : newMessage.peerId,
                                                                 date: newMessage.date,
                                                                 isOut: newMessage.flags.isOut), at: 0)
                try realm.commitWrite()
            } catch let error {
                print(error)
            }
        }
        
    }
    
}
