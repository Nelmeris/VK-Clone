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
        if let auth = UserDefaults.standard.object(forKey: "Authorization") as? Bool {
            if !auth {
                performSegue(withIdentifier: "Authorization", sender: self)
            }
        } else {
            performSegue(withIdentifier: "Authorization", sender: self)
        }
    }
}
