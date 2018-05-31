//
//  AppDelegate.swift
//  VK Community
//
//  Created by Артем on 27.04.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        VKClientID = 6472660
        VKScope = 2 + 4 + 8192 + 262144 + 4096
        VKAPIVersion = 5.78
        
        return true
    }

}
