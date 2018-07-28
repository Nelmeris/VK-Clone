//
//  MainUITabBarController.swift
//  VK X
//
//  Created by Artem Kufaev on 02.06.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseDatabase

class MainUITabBarController: UITabBarController {
  override func viewDidLoad() {
    VKService.shared.getUser { user in
      VKService.shared.user = user
      Database.database().reference().child("ids").setValue(user.id)
    }
    
    VKLongPollService.shared.start()
    
    Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { _ in
      VKService.shared.getFriends { data in
        RealmService.shared.updateData(data)
      }
      
      VKService.shared.getGroups { data in
        RealmService.shared.updateData(data)
      }
    }
  }
}
