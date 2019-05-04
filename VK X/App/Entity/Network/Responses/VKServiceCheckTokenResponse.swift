//
//  VKServiceCheckTokenResponse.swift
//  VK X
//
//  Created by Artem Kufaev on 03/05/2019.
//  Copyright © 2019 NONE. All rights reserved.
//

import Foundation

struct VKServiceCheckTokenResponse: Decodable {
    let success: Int
    let userId: Int
    let date: Date
    let expire: Date
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case userId = "user_id"
        case date = "date"
        case expire = "expire"
    }
}
