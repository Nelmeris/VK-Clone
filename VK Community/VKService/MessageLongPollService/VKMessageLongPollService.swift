//
//  VKMessageLongPollService.swift
//  VK Community
//
//  Created by Артем on 03.06.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import RealmSwift

class VKMessageLongPollService {
    
    static func loadLongPollData(completion: @escaping () -> Void) {
        VKService.request(method: "messages.getLongPollServer") { (response: VKDataBaseResponseModel<VKMessageLongPollServer>) in
            let data = [response.response!]
            RealmResaveData(data)
            completion()
        }
    }
    
    static func startLongPoll(ts: Int) {
        let longPollData = (RealmLoadData()! as Results<VKMessageLongPollServer>)[0]
        VKService.request(url: "https://\(longPollData.server)?act=a_check&key=\(longPollData.key)&ts=\(ts)&wait=30&mode=104&version=3") { (response: VKResponseModel<VKUpdatesModel>) in
            VKMessageLongPollService.startLongPoll(ts: response.response.ts)
            
            DispatchQueue.main.async {
                
                let visibleViewController = getVisibleViewController()
                
                DispatchQueue.global().async {
                    for update in response.response.updates {
                        VKMessageLongPollService.updateProcessing(visibleViewController, update)
                    }
                }
                
            }
        }
    }
    
    static func updateProcessing(_ visibleViewController: UIViewController?, _ update: VKUpdatesModel.Update) {
        switch update.code {
        case 4:
            guard visibleViewController == nil else {
                if let controller = visibleViewController! as? MessagesUIViewController {
                    Code4MessageProcessing(controller, update)
                }
                if let controller = visibleViewController! as? DialogsUITableViewController {
                    Code4DialogProcessing(controller, update)
                }
                return
            }
            
            Code4AnotherProcessing(update)
            return
            
        case 6:
            guard visibleViewController == nil else {
                if let controller = visibleViewController! as? MessagesUIViewController {
                    Code6MessageProcessing(controller, update)
                }
                return
            }
            return
            
        case 7:
            guard visibleViewController == nil else {
                if let controller = visibleViewController! as? MessagesUIViewController {
                    Code6MessageProcessing(controller, update)
                }
                return
            }
            return
            
        case 8:
            guard visibleViewController == nil else {
                if let controller = visibleViewController! as? DialogsUITableViewController {
                    Code8DialogProcessing(controller, update)
                }
                return
            }
            return
            
        case 9:
            guard visibleViewController == nil else {
                if let controller = visibleViewController! as? DialogsUITableViewController {
                    Code9DialogProcessing(controller, update)
                }
                return
            }
            return
            
        default: break
        }
    }
    
}
