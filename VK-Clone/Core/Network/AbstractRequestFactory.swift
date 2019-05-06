//
//  AbstractRequestFactory.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 23/04/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Alamofire

protocol AbstractRequestFactory {
    var errorParser: AbstractErrorParser { get }
    var sessionManager: SessionManager { get }
    var queue: DispatchQueue? { get }
    var group: RequestGroup { get }
    
    func request<T: Decodable>(
        request: URLRequestConvertible,
        container: [String]?,
        completionHandler: @escaping (DataResponse<T>) -> Void)
}

extension AbstractRequestFactory {
    
    public func request<T: Decodable>(
        request: URLRequestConvertible,
        container: [String]? = nil,
        completionHandler: @escaping (DataResponse<T>) -> Void) {
        queue?.sync {
            group.wait()
            group.start()
            usleep(group.delayTime)
            self.sessionManager
                .request(request)
                .responseCodable(errorParser: self.errorParser, queue: self.queue, group: group, container: container, completionHandler: completionHandler)
        }
    }
    
}

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
