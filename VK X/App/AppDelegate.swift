//
//  AppDelegate.swift
//  VK X
//
//  Created by Artem Kufaev on 27.04.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Стирание данных допустимо в учебных рамках
    Realm.Configuration.defaultConfiguration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)

    FirebaseApp.configure()

    GMSServices.provideAPIKey("AIzaSyBgtTqAuBLc5y0Sr4hOG9G8dSJqbjMKK14")

    return true
  }
}
