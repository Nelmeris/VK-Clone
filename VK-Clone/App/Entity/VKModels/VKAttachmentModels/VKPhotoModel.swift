//
//  VKPhotoModel.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 11.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import Foundation

struct VKPhotoModel: Decodable {
    let id: Int
    let albumId: Int
    let ownerId: Int
    let userId: Int?
    let text: String
    let addingDate: Date
    
    var sizes: [VKPhotoSizeModel]
    
    let width: Int?
    let height: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case albumId = "album_id"
        case ownerId = "owner_id"
        case userId = "user_id"
        case text
        case addingDate = "date"
        case sizes, width, height
    }
    
    init(from decoder: Decoder) throws {
        let containers = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try containers.decode(Int.self, forKey: .id)
        albumId = try containers.decode(Int.self, forKey: .albumId)
        ownerId = try containers.decode(Int.self, forKey: .ownerId)
        if let userId = try? containers.decode(Int.self, forKey: .userId) {
            self.userId = userId
        } else {
            self.userId = nil
        }
        text = try containers.decode(String.self, forKey: .text)
        addingDate = Date(timeIntervalSince1970: TimeInterval(try containers.decode(Int.self, forKey: .addingDate)))
        
        sizes = try containers.decode([VKPhotoSizeModel].self, forKey: .sizes)
        
        width = try? containers.decode(Int.self, forKey: .width)
        height = try? containers.decode(Int.self, forKey: .height)
    }
}
