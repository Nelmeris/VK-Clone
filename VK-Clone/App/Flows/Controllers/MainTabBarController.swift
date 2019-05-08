//
//  MainTabBarController.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 02.06.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        VKService.shared.getCurrentUser { user in
            VKService.shared.user = user
        }
    }
}
