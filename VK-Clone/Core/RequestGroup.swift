//
//  RequestGroup.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 08/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Foundation

class RequestGroup {
    
    private let group = DispatchGroup()
    private let requestsDelay: Double
    private var lastRequestTime: TimeInterval
    
    var delayTime: useconds_t {
        let time = requestsDelay - (Date().timeIntervalSince1970 - lastRequestTime)
        return useconds_t(time >= 0 ? time * 1_000_000 : 0)
    }
    
    init(delay: Double) {
        requestsDelay = delay
        lastRequestTime = Date().timeIntervalSince1970 - delay
    }
    
    func setLastRequestTime(from: Date) {
        lastRequestTime = from.timeIntervalSince1970
    }
    
    func wait() {
        group.wait()
    }
    
    func start() {
        group.enter()
    }
    
    func end() {
        lastRequestTime = Date().timeIntervalSince1970
        group.leave()
    }
    
}
