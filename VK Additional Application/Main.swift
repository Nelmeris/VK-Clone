//
//  Main.swift
//  VK Additional Application
//
//  Created by Артем on 29.04.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit

class Main: UIViewController {
    override func viewDidLoad() {
        if true {
            performSegue(withIdentifier: "Auth", sender: self)
        }
    }
}
