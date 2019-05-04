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
    private var url: String {
        return "https://\(longPollData.server)?act=a_check&key=\(longPollData.key)&ts=\(longPollData.ts)&wait=\(parameters!.wait)&mode=\(parameters!.mode)&version=\(parameters!.version)"
    }
    private var parameters: (wait: Int, mode: Int, version: Int)!
    
    override func main() {
        self.parameters = (30, 104, 3)
        
        loadData {
            self.request = Alamofire.request(self.url)
            
            self.repeat()
        }
    }
    
    private var request: DataRequest!
    
    /// Получение новых данных для LongPoll
    func loadData(completion: @escaping () -> Void) {
        VKService.shared.getLongPollServer { response in
            guard let response = response.value else { return }
            self.longPollData = response
            completion()
        }
    }
    
    func `repeat`() {
        self.startRequest { response in
            self.longPollData.ts = response.ts
            self.repeat()
            
            for update in response.updates {
                self.updateProcessing(update)
            }
        }
    }
    
    func startRequest(completion: @escaping(VKMessageUpdatesModel) -> Void = {_ in}) {
        self.request = Alamofire.request(self.url)
        
        self.request.responseData(queue: DispatchQueue.global()) { response in
            guard let response = response.value else { return }
            do {
                let json = try! JSON(data: response)
                
                let updates = VKMessageUpdatesModel(json)
                
                completion(updates)
            } catch let error {
                print(error)
            }
        }
    }
    
    func updateProcessing(_ update: VKUpdateModel) {
        switch update.code {
        case 4:
            self.Code4Processing(update)
            
        case 6:
            self.Code6Processing(update)
            
        case 7:
            self.Code7Processing(update)
            
        case 8:
            self.Code8Processing(update)
            
        case 9:
            self.Code9Processing(update)
            
        default: break
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
