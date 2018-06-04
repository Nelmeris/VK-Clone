//
//  VKMessageUpdateCode6Processing.swift
//  VK Community
//
//  Created by Артем on 03.06.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import RealmSwift

extension VKMessageLongPollService {
    
    static func Code6MessageProcessing(_ controller: MessagesUIViewController,_ update: VKUpdatesModel.Update) {
        
        let readMessages = update.update as! VKUpdateReadMessages
        guard readMessages.peer_id == controller.dialogId else { return }
        
        DispatchQueue.main.async {
            do {
                let realm = try Realm()
                realm.beginWrite()
                for index in 0...controller.dialog.messages.count - 1 {
                    if controller.dialog.messages[index].id <= readMessages.local_id && controller.dialog.in_read <= controller.dialog.messages[index].id {
                        controller.dialog.messages[index].read_state = 1
                    }
                }
                controller.dialog.in_read = readMessages.local_id
                try realm.commitWrite()
            } catch let error {
                print(error)
            }
        }
        
    }
    
}
