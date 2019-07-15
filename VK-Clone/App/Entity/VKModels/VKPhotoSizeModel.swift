//
//  VKPhotoSizeModel.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 31.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import Foundation

enum VKPhotoSizeTypes: String, Decodable {
    case s, m, x, o, p, q, r, y, z, w
    case a, b, c, d, e, k, l, type // ????
    case undef
}

struct VKPhotoSizeModel: Decodable {
    let type: VKPhotoSizeTypes
    let url: URL
    let width: Int
    let height: Int
    
    enum CodingKeys: String, CodingKey {
        case type, url, width, height
    }
    
    init(from decoder: Decoder) throws {
        let containers = try decoder.container(keyedBy: CodingKeys.self)
        
        url = URL(string: try containers.decode(String.self, forKey: .url))!
        width = try containers.decode(Int.self, forKey: .width)
        height = try containers.decode(Int.self, forKey: .height)
        type = VKPhotoSizeTypes(rawValue: try containers.decode(String.self, forKey: .type)) ?? .undef
    }
}
