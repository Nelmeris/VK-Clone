//
//  VKDocModel.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 04/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Foundation

enum VKDocTypes: Int, Decodable {
    case txt = 1, archive, gif, img, audio, video, eBook, undef
}

struct VKDocModel: Decodable {
    let id: Int
    let ownerId: Int
    let title: String
    let size: Int
    let ext: String
    let url: URL
    let date: Date
    let type: VKDocTypes
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerId = "owner_id"
        case title, size, ext, url, date, type
    }
    
    init(from decoder: Decoder) throws {
        let containers = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try containers.decode(Int.self, forKey: .id)
        ownerId = try containers.decode(Int.self, forKey: .ownerId)
        title = try containers.decode(String.self, forKey: .title)
        size = try containers.decode(Int.self, forKey: .size)
        ext = try containers.decode(String.self, forKey: .ext)
        url = URL(string: try containers.decode(String.self, forKey: .url))!
        date = Date(timeIntervalSince1970: TimeInterval(try containers.decode(Int.self, forKey: .date)))
        type = VKDocTypes(rawValue: try containers.decode(Int.self, forKey: .type))!
    }
}
