//
//  MainTabBarController.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 02.06.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private struct NibController {
        let storyboardName: String
        let tabBarIconName: String
    }
    
    private let dataOfControllers: [NibController] = [
        NibController(storyboardName: "NewsFeed", tabBarIconName: "NewsIcon"),
        NibController(storyboardName: "Friends", tabBarIconName: "FriendsIcon"),
        NibController(storyboardName: "Groups", tabBarIconName: "GroupsIcon")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
        
        VKServiceUsersLoggerProxy().getCurrentUser {
            VKService.shared.user = $0
        }
    }
    
    private func configureViewControllers() {
        var viewControllers = [UIViewController]()
        for data in dataOfControllers {
            let storyboard = UIStoryboard(name: data.storyboardName, bundle: nil)
            guard let controller = storyboard.instantiateInitialViewController() else { continue }
            let tabBarIcon = UIImage(named: data.tabBarIconName)
            let tag = viewControllers.count
            let tabBarItem = UITabBarItem(title: nil, image: tabBarIcon, tag: tag)
            controller.tabBarItem = tabBarItem
            let navControl = UINavigationController(rootViewController: controller)
            navControl.view.backgroundColor = UIColor(named: "NavigationColor")
            viewControllers.append(navControl)
        }
        self.viewControllers = viewControllers
    }
    
}
