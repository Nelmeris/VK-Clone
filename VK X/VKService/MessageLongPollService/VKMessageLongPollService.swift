//
//  VKLongPollOperation.swift
//  VK X
//
//  Created by Artem Kufaev on 03.06.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON

class VKLongPollOperation: Operation {
  enum State: String {
    case ready, executing, finished
    fileprivate var keyPath: String {
      return "is" + rawValue.capitalized
    }
  }
  
  private var state = State.ready {
    willSet {
      willChangeValue(forKey: state.keyPath)
      willChangeValue(forKey: newValue.keyPath)
    }
    didSet {
      didChangeValue(forKey: state.keyPath)
      didChangeValue(forKey: oldValue.keyPath)
    }
  }
  
  override var isAsynchronous: Bool {
    return true
  }
  
  override var isReady: Bool {
    return super.isReady && state == .ready
  }
  
  override var isExecuting: Bool {
    return state == .executing
  }
  
  override var isFinished: Bool {
    return state == .finished
  }
  
  override func start() {
    if isCancelled {
      state = .finished
    } else {
      main()
      state = .executing
    }
  }
  
  override func cancel() {
    request.cancel()
    super.cancel()
    state = .finished
  }
  
  private var longPollData: VKMessageLongPollServerModel!
  private var url: String!
  private var wait: Int!
  private var mode: Int!
  private var version: Int!
  
  func getUrl() {
    url = "https://\(longPollData.server)?act=a_check&key=\(longPollData.key)&ts=\(longPollData.ts)&wait=\(wait!)&mode=\(mode!)&version=\(version!)"
  }
  
  override func main() {
    self.wait = 30
    self.mode = 104
    self.version = 3
    
    loadData {
      self.getUrl()
      self.request = Alamofire.request(self.url)
      
      self.repeat()
    }
  }
  
  private var request: DataRequest!
  
  /// Получение новых данных для LongPoll
  func loadData(completion: @escaping () -> Void) {
    VKService.shared.request(method: "messages.getLongPollServer") { (response: VKMessageLongPollServerModel) in
      self.longPollData = response
      completion()
    }
  }
  
  func `repeat`() {
    self.startRequest { response in
      self.longPollData.ts = response.ts
      self.getUrl()
      self.repeat()
      
      for update in response.updates {
        self.updateProcessing(update)
      }
    }
  }
  
  func startRequest(completion: @escaping(VKMessageUpdatesModel) -> Void = {_ in}) {
    self.request = Alamofire.request(self.url)
    
    self.request.responseData(queue: DispatchQueue.global()) { response in
      do {
        let json = try VKService.shared.getJSONResponse(response)
        
        let updates = VKMessageUpdatesModel(json)
        
        completion(updates)
      } catch let error {
        print(error)
      }
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

class VKLongPollService {
  private init() {}
  static let shared = VKLongPollService()
  
  var operation: VKLongPollOperation?
  
  func start() {
    operation = VKLongPollOperation()
    OperationQueue.main.addOperation(operation!)
  }
}
