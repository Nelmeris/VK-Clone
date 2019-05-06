//
//  VKAvatarModel.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 05/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Foundation

struct VKAvatarModel: Decodable, Hashable {
    
    let photo50: URL
    let photo100: URL
    let photoOriginal: URL?
    
    enum CodingKeys: String, CodingKey {
        case photo50 = "photo_50"
        case photo100 = "photo_100"
        case photoOriginal = "photo_200"
    }
    
    init(from decoder: Decoder) throws {
        let containers = try decoder.container(keyedBy: CodingKeys.self)
        
        photo50 = URL(string: try containers.decode(String.self, forKey: .photo50))!
        photo100 = URL(string: try containers.decode(String.self, forKey: .photo100))!
        photoOriginal = URL(string: (try? containers.decode(String.self, forKey: .photoOriginal)) ?? "")
    }
    
    static func == (lhs: VKAvatarModel, rhs: VKAvatarModel) -> Bool {
        return lhs.photo50 == rhs.photo50 &&
            lhs.photo100 == rhs.photo100 &&
            lhs.photoOriginal == rhs.photoOriginal
    }
    
}
