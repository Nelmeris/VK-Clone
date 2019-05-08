//
//  VKGetSecureTokenResponse.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 03/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Foundation

struct VKGetSecureTokenResponse: Decodable {
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case token = "access_token"
    }
}
