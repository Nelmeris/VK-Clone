//
//  VKMessageLongPollService.swift
//  VK X
//
//  Created by Artem Kufaev on 03.06.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON

class VKMessageLongPollService {
  static func loadLongPollData(completion: @escaping () -> Void) {
    VKService.shared.request(method: "messages.getLongPollServer") { (response: VKRealmResponseModel<VKMessageLongPollServerModel>) in
      let data = [response.response!]
      RealmService.resaveData(data)
      completion()
    }
  }
  
  static func startLongPoll(ts: Int, wait: Int = 30, mode: Int = 104, version: Int = 3) {
    let longPollData = (RealmService.loadData()! as Results<VKMessageLongPollServerModel>).first!
    let url = "https://\(longPollData.server)?act=a_check&key=\(longPollData.key)&ts=\(ts)&wait=\(wait)&mode=\(mode)&version=\(version)"
    
    VKMessageLongPollService.request(url) { response in
      VKMessageLongPollService.startLongPoll(ts: response.response.ts)
      
      DispatchQueue.main.async {
        let visibleViewController = getVisibleViewController()
        
        DispatchQueue.global().async {
          response.response.updates.forEach { update in
            VKMessageLongPollService.updateProcessing(visibleViewController, update)
          }
        }
      }
    }
    
  }
  
  static func request(_ url: String, completion: @escaping(VKResponseModel<VKMessageUpdatesModel>) -> Void = {_ in}) {
    Alamofire.request(url).responseData(queue: DispatchQueue.global()) { response in
      do {
        let json = try VKService.shared.getJSONResponse(response)
        
        let updates = VKResponseModel<VKMessageUpdatesModel>(json)
        
        completion(updates)
      } catch {}
    }
  }
  
  static func updateProcessing(_ visibleViewController: UIViewController?, _ update: VKMessageUpdatesModel.Update) {
    switch update.code {
    case 4:
      guard visibleViewController == nil else {
        if let controller = visibleViewController! as? MessagesUIViewController {
          Code4MessageProcessing(controller, update)
        }
        if let controller = visibleViewController! as? DialogsUITableViewController {
          Code4DialogProcessing(controller, update)
        }
        return
      }
      return
      
    case 6:
      guard visibleViewController == nil else {
        if let controller = visibleViewController! as? MessagesUIViewController {
          Code6MessageProcessing(controller, update)
        }
        return
      }
      return
      
    case 7:
      guard visibleViewController == nil else {
        if let controller = visibleViewController! as? MessagesUIViewController {
          Code6MessageProcessing(controller, update)
        }
        return
      }
      return
      
    case 8:
      guard visibleViewController == nil else {
        if let controller = visibleViewController! as? DialogsUITableViewController {
          Code8DialogProcessing(controller, update)
        }
        return
      }
      return
      
    case 9:
      guard visibleViewController == nil else {
        if let controller = visibleViewController! as? DialogsUITableViewController {
          Code9DialogProcessing(controller, update)
        }
        return
      }
      return
      
    default: break
    }
  }
}
