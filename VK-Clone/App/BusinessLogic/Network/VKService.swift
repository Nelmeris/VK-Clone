//
//  VKService.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 09.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class VKService: AbstractRequestFactory {
    var errorParser: AbstractErrorParser
    var sessionManager: SessionManager
    var queue: DispatchQueue?
    
    fileprivate let scheme = "https"
    fileprivate let host = "api.vk.com/method/"
    let clientId = 6472660
    let scope = 2 + 4 + 4096 + 8192 + 262144
    let apiVersion = 5.95
    let clientSecret = "X5InC8IYa7fpIImNWHFt"
    
    var user: VKUserModel!
    
    var lastRequestTime: DispatchTime
    let requestsDelay: TimeInterval = 1 / 3
    var delayTime: DispatchTime {
        let time = lastRequestTime + requestsDelay
        lastRequestTime = DispatchTime.now()
        return time
    }
    
    private init() {
        let factory = RequestFactory()
        let maker = factory.maker()
        self.errorParser = maker.0
        self.sessionManager = maker.1
        self.queue = maker.2
        self.lastRequestTime = DispatchTime.now() - requestsDelay
        self.isStarted = false
        self.isPaused = false
    }
    
    static let shared = VKService()
    
    var baseUrl: URL {
        return URL(string: scheme + "://" + host)!
    }
    
    var isStarted: Bool
    var isPaused: Bool
}

extension VKService {
    
    func start() {
        self.queue?.activate()
        isStarted = true
    }
    
    func suspend() {
        self.queue?.suspend()
        isPaused = true
    }
    
    func resume() {
        self.queue?.resume()
        isPaused = false
    }
    
}
