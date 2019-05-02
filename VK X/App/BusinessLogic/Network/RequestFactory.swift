//
//  RequestFactory.swift
//  GeekShop
//
//  Created by Artem Kufaev on 23/04/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Alamofire

class RequestFactory {
    func makeErrorParser() -> AbstractErrorParser {
        return ErrorParser()
    }

    lazy var commonSessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = false
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        let manager = SessionManager(configuration: configuration)
        return manager
    }()

    let sessionQueue = DispatchQueue.global(qos: .utility)
    
    func maker() -> (AbstractErrorParser, SessionManager, DispatchQueue) {
        return (makeErrorParser(), commonSessionManager, sessionQueue)
    }
}
