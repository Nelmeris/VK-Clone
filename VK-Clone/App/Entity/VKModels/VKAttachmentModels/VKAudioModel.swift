//
//  VKAudioModel.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 04/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Foundation

struct VKAudioModel: Decodable {
    let id: Int
    let ownerId: Int
    let artist: String
    let title: String
    let duration: Int // в секундах
    let url: URL // mp3
    let lyricsId: Int // текст
    let albumId: Int
    let genreId: Int // жанр
    let addingDate: Date // дата добавления
    let isNoSearch: Bool // не выводится при поиске
    let isHq: Bool // высокое качество
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerId = "owner_id"
        case artist, title, duration, url
        case lyricsId = "lyrics_id"
        case albumId = "album_id"
        case genreId = "genre_id"
        case addingDate = "date"
        case isNoSearch = "no_search"
        case isHq = "is_hq"
    }
    
    init(from decoder: Decoder) throws {
        let containers = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try containers.decode(Int.self, forKey: .id)
        ownerId = try containers.decode(Int.self, forKey: .ownerId)
        artist = try containers.decode(String.self, forKey: .ownerId)
        title = try containers.decode(String.self, forKey: .ownerId)
        duration = try containers.decode(Int.self, forKey: .ownerId)
        url = URL(string: try containers.decode(String.self, forKey: .ownerId))!
        lyricsId = try containers.decode(Int.self, forKey: .ownerId)
        albumId = try containers.decode(Int.self, forKey: .ownerId)
        genreId = try containers.decode(Int.self, forKey: .ownerId)
        addingDate = Date(timeIntervalSince1970: TimeInterval(try containers.decode(Int.self, forKey: .ownerId)))
        isNoSearch = (try? containers.decode(Int.self, forKey: .ownerId) == 1) ?? false
        isHq = (try? containers.decode(Int.self, forKey: .ownerId) == 1) ?? false
    }
}
