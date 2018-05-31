//
//  Methods.swift
//  VK Community
//
//  Created by Артем on 29.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit

func getShortCount(_ count: Int) -> String {
    switch count {
    case let x where x >= 1000000:
        return String(format: "%.1f", Double(x) / 1000000) + "М"
    case let x where x >= 1000:
        return String(format: "%.1f", Double(x) / 1000) + "К"
    default:
        return String(count)
    }
}

func getActiveViewController() -> UIViewController {
    var topController = UIApplication.shared.keyWindow?.rootViewController
    while let presentedViewController = topController!.presentedViewController {
        topController = presentedViewController
    }
    
    return topController!
}
