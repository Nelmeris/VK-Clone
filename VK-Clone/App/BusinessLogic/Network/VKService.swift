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
    var group: RequestGroup
    
    fileprivate let scheme = "https"
    fileprivate let host = "api.vk.com/method/"
    let clientId = 6472660
    let scope = 2 + 4 + 4096 + 8192 + 262144
    let apiVersion = 5.95
    let clientSecret = "X5InC8IYa7fpIImNWHFt"
    
    var user: VKUserModel!
    
    let requestsDelay: TimeInterval = 1 / 3
    
    private init() {
        let factory = VKRequestFactory()
        errorParser = factory.makeErrorParser()
        sessionManager = factory.commonSessionManager
        queue = factory.sessionQueue
        group = RequestGroup(delay: 1 / 3)
        isStarted = false
        isPaused = false
    }
    
    static let shared = VKService()
    
    var baseUrl: URL {
        return URL(string: scheme + "://" + host)!
    }
    
    var isStarted: Bool
    var isPaused: Bool
    
    func request<T: Decodable>(request: URLRequestConvertible, completionHandler: @escaping (T) -> Void) {
        queue?.sync {
            group.wait()
            group.start()
            usleep(group.delayTime)
            self.sessionManager
                .request(request)
                .responseCodable(errorParser: errorParser, queue: queue) { (response: DataResponse<VKResponse<T>>) in
                    self.group.end()
                    switch response.result {
                    case .success(let value):
                        completionHandler(value.response)
                    case .failure(let error):
                        if let error = error as? VKErrorResponse {
                            switch error.code {
                            case 5:
                                VKTokenService.shared.delete()
                            default:
                                print(error.message)
                            }
                        } else {
                            print(error)
                        }
                        self.request(request: request, completionHandler: completionHandler)
                    }
            }
        }
        
    }
    
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
