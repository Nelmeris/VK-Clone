//
//  GetData.swift
//  VK Community
//
//  Created by Артем on 08.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import Foundation
import Alamofire

open class VK_Service {
    static let Scheme = "https"
    static let Host = "api.vk.com/method/"
    static let Version = "5.52"
    
    static func Methods(method: String, token: String, options: [String: String]? = nil) {
        var url = "\(Scheme)://\(Host)\(method)?v=\(Version)&access_token=\(token)"
        if options != nil {
            for element in options! {
                url += "&\(element.key)=\(element.value)"
            }
        }
        Alamofire.request(url).responseJSON { response in
            print(response.value)
        }
    }
}
