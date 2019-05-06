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
    
    func request<T: Decodable>(
        request: URLRequestConvertible,
        delay: DispatchTime,
        group: DispatchGroup?,
        container: [String]?,
        completionHandler: @escaping (DataResponse<T>) -> Void)
}

extension AbstractRequestFactory {
    
    public func request<T: Decodable>(
        request: URLRequestConvertible,
        delay: DispatchTime,
        group: DispatchGroup? = nil,
        container: [String]? = nil,
        completionHandler: @escaping (DataResponse<T>) -> Void) {
        queue?.sync {
            print(delay)
            group?.wait(timeout: delay)
            group?.enter()
            self.sessionManager
                .request(request)
                .responseCodable(errorParser: self.errorParser, queue: self.queue, group: group, container: container, completionHandler: completionHandler)
        }
    }

}
