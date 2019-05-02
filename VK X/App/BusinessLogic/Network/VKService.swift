//
//  VKService.swift
//  VK X
//
//  Created by Artem Kufaev on 09.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift
import FirebaseDatabase

class VKService: AbstractRequestFactory {
    var errorParser: AbstractErrorParser
    var sessionManager: SessionManager
    var queue: DispatchQueue?
    
    fileprivate let scheme = "https"
    fileprivate let host = "api.vk.com/method/"
    let clientId = 6472660
    let scope = 2 + 4 + 4096 + 8192 + 262144
    let apiVersion = 5.78
    
    var user: VKUserModel! {
        willSet {
            Database.database().reference().child("ids").setValue(newValue.id)
        }
    }
    
    private init() {
        let factory = RequestFactory()
        let maker = factory.maker()
        self.errorParser = maker.0
        self.sessionManager = maker.1
        self.queue = maker.2
    }

    static let shared = VKService()
    
    var baseUrl: URL {
        return URL(string: scheme + "://" + host)!
    }
}

extension VKService {
    
    struct Execute: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = "execute"
        
        let code: String
        var parameters: Parameters? {
            return [
                "code": code
            ]
        }
    }
    
}
