//
//  VKMessageUpdateCode7Processing.swift
//  VK Community
//
//  Created by Артем on 03.06.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import RealmSwift

extension VKMessageLongPollService {
    
    static func Code7MessageProcessing(_ controller: MessagesUIViewController, _ update: VKMessageUpdatesModel.Update) {
        
        let readMessages = update.update as! VKMessageUpdateReadMessagesModel
        guard readMessages.peerId == controller.dialogId else { return }
        
        DispatchQueue.main.async {
            do {
                let realm = try Realm()
                realm.beginWrite()
                for index in 0...controller.dialog.messages.count - 1{
                    if controller.dialog.messages[index].id <= readMessages.localId && controller.dialog.outRead <= controller.dialog.messages[index].id {
                        controller.dialog.messages[index].isRead = true
                    }
                }
                controller.dialog.outRead = readMessages.localId
                try realm.commitWrite()
            } catch let error {
                print(error)
            }
        }
        
    }
    
}
