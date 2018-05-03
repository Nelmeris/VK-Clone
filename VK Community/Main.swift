//
//  Main.swift
//  VK Community
//
//  Created by Артем on 29.04.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit

class Main: UITabBarController {
    override func viewDidAppear(_ animated: Bool) {
        if !auth {
            performSegue(withIdentifier: "Authorization", sender: self)
        }
    }
}
