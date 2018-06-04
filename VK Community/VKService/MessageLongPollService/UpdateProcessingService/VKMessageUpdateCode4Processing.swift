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
    
    static func Code4DialogProcessing(_ controller: DialogsUITableViewController, _ update: VKUpdatesModel.Update) {
        
        let newMessage = update.update as! VKUpdateNewMessage
        
        DispatchQueue.main.async {
            let dialogs: Results<VKDialogModel> = RealmService.loadData()!
            
            let dialog = dialogs.filter("id = \(newMessage.peer_id)")[0]
            
            do {
                let realm = try Realm()
                realm.beginWrite()
                
                dialog.message.id = newMessage.message_id
                dialog.message.body = newMessage.text
                dialog.message.out = newMessage.flags & 2 == 2 ? 1 : 0
                dialog.message.date = newMessage.timestamp
                dialog.message.user_id = 0
                
                try realm.commitWrite()
            } catch let error {
                print(error)
            }
        }
        
    }
    
    static func Code4MessageProcessing(_ controller: MessagesUIViewController, _ update: VKUpdatesModel.Update) {
        
        let newMessage = update.update as! VKUpdateNewMessage
        
        guard newMessage.peer_id == controller.dialogId else { return }
        
        DispatchQueue.main.async {
            do {
                let realm = try Realm()
                realm.beginWrite()
                controller.dialog.messages.insert(VKMessageModel(id: newMessage.message_id,
                                                                 text: newMessage.text,
                                                                 from_id: newMessage.flags & 2 == 2 ? VKService.user.id : newMessage.peer_id,
                                                                 date: newMessage.timestamp), at: 0)
                try realm.commitWrite()
            } catch let error {
                print(error)
            }
        }
        
    }
    
}
