//
//  GetData.swift
//  VK Community
//
//  Created by Артем on 08.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import Foundation
import Alamofire

let VK_API_Scheme = "https"
let VK_API_Host = "api.vk.com/method/"
let VK_API_Version = "5.52"

func VK_API_Methods(method: String, token: String, options: [String: String]? = nil) {
    var url = "\(VK_API_Scheme)://\(VK_API_Host)\(method)?v=\(VK_API_Version)&access_token=\(token)"
    if options != nil {
        for element in options! {
            url += "&\(element.key)=\(element.value)"
        }
    }
    Alamofire.request(url).responseJSON { response in
        print(response.value)
    }
}
