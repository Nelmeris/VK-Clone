//
//  RequestFactory.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 23/04/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Alamofire

class VKRequestFactory {
    func makeErrorParser() -> AbstractErrorParser {
        return VKErrorParser()
    }
    
    lazy var commonSessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = false
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        let manager = SessionManager(configuration: configuration)
        return manager
    }()
    
    let sessionQueue = DispatchQueue(label: "VKServiceRequestQueue", qos: .userInteractive, attributes: [.concurrent, .initiallyInactive])
}
