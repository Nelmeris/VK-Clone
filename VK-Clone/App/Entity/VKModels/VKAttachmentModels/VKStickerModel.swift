//
//  VKStickerModel.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 04/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Foundation

struct VKStickerModel: Decodable {
    let id: Int
    let productId: Int?
    let images: [VKPhotoSizeModel]
    let imagesWithBackground: [VKPhotoSizeModel]
    
    enum CodingKeys: String, CodingKey {
        case id = "sticker_id"
        case productId = "product_id"
        case images = "images"
        case imagesWithBackground = "images_with_background"
    }
    
    init(from decoder: Decoder) throws {
        let containers = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try containers.decode(Int.self, forKey: .id)
        productId = try? containers.decode(Int.self, forKey: .productId)
        images = try containers.decode([VKPhotoSizeModel].self, forKey: .images)
        imagesWithBackground = try containers.decode([VKPhotoSizeModel].self, forKey: .imagesWithBackground)
    }
}
