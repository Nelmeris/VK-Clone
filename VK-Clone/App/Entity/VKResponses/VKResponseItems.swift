//
//  VKResponseItems.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 03/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Foundation

struct VKResponseItems<T: Decodable>: Decodable {
    let count: Int
    let items: T
    
    enum CodingKeys: String, CodingKey {
        case count
        case items
    }
    
    init(from decoder: Decoder) throws {
        let containers = try decoder.container(keyedBy: CodingKeys.self)
        
        count = try containers.decode(Int.self, forKey: .count)
        items = try containers.decode(T.self, forKey: .items)
    }
}
