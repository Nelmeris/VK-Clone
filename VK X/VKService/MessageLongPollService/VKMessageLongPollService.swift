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
  private init() {}
  static public let shared = VKMessageLongPollService()
  
  /// Получение новых данных для LongPoll
  func loadLongPollData(completion: @escaping () -> Void) {
    VKService.shared.request(method: "messages.getLongPollServer") { (response: VKMessageLongPollServerModel) in
      let data = [response]
      RealmService.resaveData(data)
      completion()
    }
  }
  
  /// Начало цикла LongPoll
  func startLongPoll(ts: Int, wait: Int = 30, mode: Int = 104, version: Int = 3) {
    let longPollData = (RealmService.loadData()! as Results<VKMessageLongPollServerModel>).first!
    let url = "https://\(longPollData.server)?act=a_check&key=\(longPollData.key)&ts=\(ts)&wait=\(wait)&mode=\(mode)&version=\(version)"
    
    request(url) { response in
      self.startLongPoll(ts: response.ts)
      
      for update in response.updates {
        self.updateProcessing(update)
      }
    }
    
  }
  
  func request(_ url: String, completion: @escaping(VKMessageUpdatesModel) -> Void = {_ in}) {
    Alamofire.request(url).responseData(queue: DispatchQueue.global()) { response in
      do {
        let json = try VKService.shared.getJSONResponse(response)
        
        let updates = VKMessageUpdatesModel(json)
        
        completion(updates)
      } catch {}
    }
  }
  
  func updateProcessing(_ update: VKUpdateModel) {
    DispatchQueue.main.async {
      let visibleViewController = getVisibleViewController()
      DispatchQueue.global().async {
        switch update.code {
        case 4:
          guard visibleViewController == nil else {
            if let controller = visibleViewController! as? MessagesUIViewController {
              self.Code4MessageProcessing(controller, update)
            }
            if let controller = visibleViewController! as? DialogsUITableViewController {
              self.Code4DialogProcessing(controller, update)
            }
            return
          }
          return
          
        case 6:
          guard visibleViewController == nil else {
            if let controller = visibleViewController! as? MessagesUIViewController {
              self.Code6MessageProcessing(controller, update)
            }
            return
          }
          return
          
        case 7:
          guard visibleViewController == nil else {
            if let controller = visibleViewController! as? MessagesUIViewController {
              self.Code7MessageProcessing(controller, update)
            }
            if let controller = visibleViewController! as? DialogsUITableViewController {
              self.Code7DialogProcessing(controller, update)
            }
            return
          }
          return
          
        case 8:
          guard visibleViewController == nil else {
            if let controller = visibleViewController! as? DialogsUITableViewController {
              self.Code8DialogProcessing(controller, update)
            }
            return
          }
          return
          
        case 9:
          guard visibleViewController == nil else {
            if let controller = visibleViewController! as? DialogsUITableViewController {
              self.Code9DialogProcessing(controller, update)
            }
            return
          }
          return
          
        default: break
        }
      }
    }
  }
}
