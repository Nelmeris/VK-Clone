//
//  VKGraffitiModel.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 04/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Foundation

struct VKGraffitiModel: Decodable {
    let id: Int
    let ownerId: Int
    let previewPhotoUrl: URL
    let fullPhotoUrl: URL
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerId = "owner_id"
        case previewPhotoUrl = "photo_130"
        case fullPhotoUrl = "photo_604"
    }
    
    init(from decoder: Decoder) throws {
        let containers = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try containers.decode(Int.self, forKey: .id)
        ownerId = try containers.decode(Int.self, forKey: .ownerId)
        previewPhotoUrl = URL(string: try containers.decode(String.self, forKey: .previewPhotoUrl))!
        fullPhotoUrl = URL(string: try containers.decode(String.self, forKey: .fullPhotoUrl))!
    }
}
