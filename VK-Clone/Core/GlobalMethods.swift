//
//  GlobalMethods.swift
//  VK-CLone
//
//  Created by Artem Kufaev on 29.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit

/// Форматирование больших чисел
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

/// Определение текущего контроллера
func getVisibleViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
  if let nav = base as? UINavigationController {
    let visible = nav.visibleViewController
    return getVisibleViewController(base: visible)
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

/// Установка формата даты относительно самой даты
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

/// Преобразование Date в String
func getDateString(_ date: Date) -> String {
  let dateFormatter = getDateFormatter(date)

  return dateFormatter.string(from: date)
}

func getIFAddresses() -> [String] {
    var addresses = [String]()
    
    // Get list of all interfaces on the local machine:
    var ifaddr : UnsafeMutablePointer<ifaddrs>?
    guard getifaddrs(&ifaddr) == 0 else { return [] }
    guard let firstAddr = ifaddr else { return [] }
    
    // For each interface ...
    for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
        let flags = Int32(ptr.pointee.ifa_flags)
        let addr = ptr.pointee.ifa_addr.pointee
        
        // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
        if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
            if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                
                // Convert interface address to a human readable string:
                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                if (getnameinfo(ptr.pointee.ifa_addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                    let address = String(cString: hostname)
                    addresses.append(address)
                }
            }
        }
    }
    
    freeifaddrs(ifaddr)
    return addresses
}

// Return IP address of WiFi interface (en0) as a String, or `nil`
func getWiFiAddress() -> String? {
    var address : String?
    
    // Get list of all interfaces on the local machine:
    var ifaddr : UnsafeMutablePointer<ifaddrs>?
    guard getifaddrs(&ifaddr) == 0 else { return nil }
    guard let firstAddr = ifaddr else { return nil }
    
    // For each interface ...
    for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
        let interface = ifptr.pointee
        
        // Check for IPv4 or IPv6 interface:
        let addrFamily = interface.ifa_addr.pointee.sa_family
        if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
            
            // Check interface name:
            let name = String(cString: interface.ifa_name)
            if  name == "en0" {
                
                // Convert interface address to a human readable string:
                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                            &hostname, socklen_t(hostname.count),
                            nil, socklen_t(0), NI_NUMERICHOST)
                address = String(cString: hostname)
            }
        }
    }
    freeifaddrs(ifaddr)
    
    return address
}
