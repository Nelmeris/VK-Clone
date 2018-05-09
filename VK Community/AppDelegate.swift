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
        
        // Проверка наличия токена
        guard UserDefaults.standard.value(forKey: "token") as! String? != nil else {
            return true
        }
        
        // Проверка действительности токена
        guard (UserDefaults.standard.value(forKey: "tokenDate") as! NSDate).timeIntervalSinceNow >= 0 else {
            return true
        }
        
        // Установка стандартного окна "Main"
        window?.rootViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Main")
        
        // Переход к установленному окну
        window?.makeKeyAndVisible()
        
        return true
    }


}

