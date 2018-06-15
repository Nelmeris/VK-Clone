//
//  GlobalMethods.swift
//  VK X
//
//  Created by Artem Kufaev on 29.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
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

func getActiveViewController() -> UIViewController? {
  guard var topController = UIApplication.shared.keyWindow?.rootViewController else { return nil }
  
  while let presentedViewController = topController.presentedViewController {
    topController = presentedViewController
  }
  
  return topController
}

func getVisibleViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
  if let nav = base as? UINavigationController {
    return getVisibleViewController(base: nav.visibleViewController)
  }
  
  if let tab = base as? UITabBarController,
    let selected = tab.selectedViewController {
    return getVisibleViewController(base: selected)
  }
  
  if let presented = base?.presentedViewController {
    return getVisibleViewController(base: presented)
  }
  
  return base
}

func getDateFormatter(_ date: Date) -> DateFormatter {
  let dateFormatter = DateFormatter()
  
  switch Calendar.current {
  case let x where x.component(.day, from: date) == x.component(.day, from: Date()):
    dateFormatter.dateFormat = "HH:mm"
    
  case _ where Date().timeIntervalSince(date) <= 172800:
    dateFormatter.dateFormat = "вчера"
    
  case let x where x.component(.year, from: date) == x.component(.year, from: Date()):
    dateFormatter.dateFormat = "dd MMM"
    
  default:
    dateFormatter.dateFormat = "dd.MM.yyyy"
  }
  
  return dateFormatter
}

func getDateString(_ date: Date) -> String {
  let dateFormatter = getDateFormatter(date)
  
  return dateFormatter.string(from: date)
}
