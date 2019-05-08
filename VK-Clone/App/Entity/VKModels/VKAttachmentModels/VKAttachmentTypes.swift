//
//  VKAttachmentTypes.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 03/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Foundation

enum VKAttachmentTypes: String, Decodable {
    case photo, graffiti, sticker
    case postedPhoto = "posted_photo"
    case photosList = "photos_list"
    case video, audio
    case doc, note, link
    case app, poll, page, market, prettyCards = "pretty_cards"
    case album, marketAlbum = "market_album"
}
