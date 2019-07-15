//
//  VKMessageModel.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 05/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Foundation

class VKMessageModel: Decodable {
    let id: Int
    let date: Date
    let peerId: Int
    let fromId: Int
    let text: String
    
    let randomId: Int?
    let ref: String
    let refSource: String
    
    let attachments: [VKAttachmentModel]?
    
    let important: Bool
    let geo: VKGeoModel
    let payload: String
    
    let fwdMessages: [VKMessageModel]
    let replyMessage: VKMessageModel
    
    enum CodingKeys: String, CodingKey {
        case id, date, peerId = "peer_id"
        case fromId = "from_id"
        case text, randomId = "random_id"
        case ref, refSource = "ref_source"
        case attachments, important, geo, payload = "payload"
        case fwdMessages = "fwd_messages"
        case replyMessage = "reply_message"
    }
    
    required init(from decoder: Decoder) throws {
        let containers = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try containers.decode(Int.self, forKey: .id)
        date = Date(timeIntervalSinceNow: TimeInterval(try containers.decode(Int.self, forKey: .date)))
        peerId = try containers.decode(Int.self, forKey: .peerId)
        fromId = try containers.decode(Int.self, forKey: .fromId)
        text = try containers.decode(String.self, forKey: .text)
        randomId = try? containers.decode(Int.self, forKey: .randomId)
        ref = try containers.decode(String.self, forKey: .ref)
        refSource = try containers.decode(String.self, forKey: .refSource)
        attachments = try? containers.decode([VKAttachmentModel].self, forKey: .attachments)
        important = try containers.decode(Bool.self, forKey: .important)
        geo = try containers.decode(VKGeoModel.self, forKey: .geo)
        payload = try containers.decode(String.self, forKey: .payload)
        fwdMessages = try containers.decode([VKMessageModel].self, forKey: .fwdMessages)
        replyMessage = try containers.decode(VKMessageModel.self, forKey: .replyMessage)
    }
}
