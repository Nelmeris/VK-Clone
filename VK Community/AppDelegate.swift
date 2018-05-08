//
//  AppDelegate.swift
//  VK Community
//
//  Created by Артем on 27.04.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Если зарегистрирован, показывам "MainController"
        // Иначе загружаем "AltController"
        if UserDefaults.standard.value(forKey: "token") == nil || (UserDefaults.standard.value(forKey: "tokenDate") as! NSDate).timeIntervalSinceNow >= 0
        {
            let mainController = storyboard.instantiateViewController(withIdentifier: "VKAuthorization")
            self.window?.rootViewController = mainController
        }
        else
        {
            let altController = storyboard.instantiateViewController(withIdentifier: "Main")
            self.window?.rootViewController = altController
        }
        
        // Заставляем окно отобразить rootViewController
        self.window?.makeKeyAndVisible()
        
        
        return true
    }


}

