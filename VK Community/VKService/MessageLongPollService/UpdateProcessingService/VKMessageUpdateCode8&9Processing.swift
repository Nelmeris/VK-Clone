//
//  VKMessageUpdateCode8&9Processing.swift
//  VK Community
//
//  Created by Артем on 04.06.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import RealmSwift

extension VKMessageLongPollService {
    
    static func Code8DialogProcessing(_ controller: DialogsUITableViewController, _ update: VKUpdatesModel.Update) {
        
        let onlineStatusChanged = update.update as! VKUpdateOnlineStatusChanged
        
        DispatchQueue.main.async {
            var dialogs: Results<VKDialogModel> = RealmService.loadData()!
            
            dialogs = dialogs.filter("id = \(-onlineStatusChanged.user_id)")
            
            if dialogs.count != 0 {
                let dialog = dialogs[0]
                
                do {
                    let realm = try Realm()
                    realm.beginWrite()
                    
                    dialog.online = 1
                    
                    try realm.commitWrite()
                } catch let error {
                    print(error)
                }
            }
        }
        
    }
    
    static func Code9DialogProcessing(_ controller: DialogsUITableViewController, _ update: VKUpdatesModel.Update) {
        
        let onlineStatusChanged = update.update as! VKUpdateOnlineStatusChanged
        
        DispatchQueue.main.async {
            var dialogs: Results<VKDialogModel> = RealmService.loadData()!
            
            dialogs = dialogs.filter("id = \(-onlineStatusChanged.user_id)")
            
            if dialogs.count != 0 {
                let dialog = dialogs[0]
                
                do {
                    let realm = try Realm()
                    realm.beginWrite()
                    
                    dialog.online = 0
                    
                    try realm.commitWrite()
                } catch let error {
                    print(error)
                }
            }
        }
        
    }
    
}
