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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.global().async {
            VKMessageLongPollService.loadLongPollData() {
                let longPollData: Results<VKMessageLongPollServer> = RealmService.loadData()!
                VKMessageLongPollService.startLongPoll(ts: longPollData[0].ts)
            }
        }
    }
    
}
