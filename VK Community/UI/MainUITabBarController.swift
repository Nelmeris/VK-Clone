//
//  MainUITabBarController.swift
//  VK Community
//
//  Created by Артем on 02.06.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import RealmSwift

class MainUITabBarController: UITabBarController {
    
    override func viewDidLoad() {
        VKService.shared.request(method: "users.get", parameters: ["fields" : "photo_100"], queue: DispatchQueue.main) { (response: VKItemModel<VKUserModel>) in
            VKService.shared.user = response.item
        }
        
        VKMessageLongPollService.loadLongPollData() {
            let longPollData: Results<VKMessageLongPollServerModel> = RealmService.loadData()!
            VKMessageLongPollService.startLongPoll(ts: longPollData.first!.ts)
        }
        
        DispatchQueue.global().async {
            while true {
                VKService.shared.getFriends { data in
                    RealmService.updateData(data)
                }
                
                VKService.shared.getGroups { data in
                    RealmService.updateData(data)
                }
                
                sleep(30)
            }
        }
    }
    
}
