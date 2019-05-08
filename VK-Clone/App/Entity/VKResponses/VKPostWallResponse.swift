//
//  VKPostWallResponse.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 05/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Foundation

struct VKPostWallResponse: Decodable {
    let postId: Int
    
    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
    }
}
