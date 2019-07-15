//
//  VKLinkModel.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 04/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Foundation

struct VKLinkModel: Decodable {
    let url: URL
    /// Заголовок
    let title: String
    /// Подпись
    let caption: String?
    /// Описание
    let description: String
    /// Изображение превью
    let photo: VKPhotoModel?
//    let product:
//    let button:
    /// Идентификатор вики-страницы с контентом для предпросмотра содержимого страницы
    let previewPageId: String?
    /// URL страницы с контентом для предпросмотра содержимого страницы
    let previewUrl: URL
    
    enum CodingKeys: String, CodingKey {
        case url, title, caption, description, photo
        case previewPageId = "preview_page"
        case previewUrl = "preview_url"
    }
    
    init(from decoder: Decoder) throws {
        let containers = try decoder.container(keyedBy: CodingKeys.self)
        
        url = URL(string: try containers.decode(String.self, forKey: .url))!
        title = try containers.decode(String.self, forKey: .title)
        caption = try? containers.decode(String.self, forKey: .caption)
        description = try containers.decode(String.self, forKey: .description)
        photo = try? containers.decode(VKPhotoModel.self, forKey: .photo)
        previewPageId = try? containers.decode(String.self, forKey: .previewPageId)
        previewUrl = URL(string: try containers.decode(String.self, forKey: .previewUrl))!
    }
}
