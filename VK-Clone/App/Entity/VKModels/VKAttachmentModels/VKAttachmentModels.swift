//
//  VKAttachmentModels.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 03/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Foundation

struct VKAttachmentModel: Decodable {
    let type: VKAttachmentTypes
    let attachment: Decodable
    
    enum CodingKeys: String, CodingKey {
        case type
        case photo, graffiti, sticker
        case postedPhoto = "posted_photo"
        case photosList = "photos_list"
        case video, audio
        case doc, note, link
        case app, poll, page, market, prettyCards = "pretty_cards"
        case album, marketAlbum = "market_album"
    }
    
    enum Errores: Error {
        case err
    }
    
    init(from decoder: Decoder) throws {
        let containers = try decoder.container(keyedBy: CodingKeys.self)
        type = VKAttachmentTypes(rawValue: try containers.decode(String.self, forKey: .type))!
        switch type {
        case .photo:
            attachment = try containers.decode(VKPhotoModel.self, forKey: .photo)
        case .video:
            attachment = try containers.decode(VKVideoModel.self, forKey: .video)
        case .doc:
            attachment = try containers.decode(VKDocModel.self, forKey: .doc)
        case .audio:
            attachment = try containers.decode(VKAudioModel.self, forKey: .audio)
        case .link:
            attachment = try containers.decode(VKLinkModel.self, forKey: .link)
        case .graffiti:
            attachment = try containers.decode(VKGraffitiModel.self, forKey: .graffiti)
        case .sticker:
            attachment = try containers.decode(VKStickerModel.self, forKey: .sticker)
        case .postedPhoto:
            print("ERROR: lost postedPhoto")
            throw Errores.err
        case .photosList:
            print("ERROR: lost photosList")
            throw Errores.err
        case .note:
            print("ERROR: lost note")
            throw Errores.err
        case .app:
            print("ERROR: lost app")
            throw Errores.err
        case .poll:
            print("ERROR: lost poll")
            throw Errores.err
        case .page:
            print("ERROR: lost page")
            throw Errores.err
        case .market:
            print("ERROR: lost market")
            throw Errores.err
        case .marketAlbum:
            print("ERROR: lost marketAlbum")
            throw Errores.err
        case .prettyCards:
            print("ERROR: lost prettyCards")
            throw Errores.err
        case .album:
            print("ERROR: lost album")
            throw Errores.err
        }
    }
}
