//
//  VKCheckTokenResponse.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 03/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Foundation

struct VKCheckTokenResponse: Decodable {
    let success: Int
    let userId: Int
    let date: Date
    let expire: Date
    
    enum CodingKeys: String, CodingKey {
        case success
        case userId = "user_id"
        case date
        case expire
    }
    
    init(from decoder: Decoder) throws {
        let containers = try decoder.container(keyedBy: CodingKeys.self)
        
        success = try containers.decode(Int.self, forKey: .success)
        userId = try containers.decode(Int.self, forKey: .userId)
        let dateInt = try containers.decode(Int.self, forKey: .date)
        let expireInt = try containers.decode(Int.self, forKey: .expire)
        
        date = Date(timeIntervalSince1970: TimeInterval(dateInt))
        expire = Date(timeIntervalSince1970: TimeInterval(expireInt))
    }
}
