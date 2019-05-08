//
//  VKGroupModel.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 10.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import Foundation

enum VKGroupTypes: String, Decodable {
    case group, page, event
}

enum VKGroupAdminLevels: Int, Decodable {
    case moderator = 1, editor, admin
}

struct VKGroupModel: Decodable, Hashable {
    
    let id: Int
    let name: String
    let screenName: String
    let isClosed: Bool
    let type: VKGroupTypes
    let isAdmin: Bool
    let adminLevel: VKGroupAdminLevels?
    let isMember: Bool
    let isAdvertiser: Bool
    let avatar: VKAvatarModel
    let membersCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case screenName = "screen_name"
        case isClosed = "is_closed"
        case type = "type"
        case isAdmin = "is_admin"
        case isMember = "is_member"
        case isAdvertiser = "is_advertiser"
        case membersCount = "members_count"
    }
    
    init(from decoder: Decoder) throws {
        let containers = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try containers.decode(Int.self, forKey: .id)
        name = try containers.decode(String.self, forKey: .name)
        screenName = try containers.decode(String.self, forKey: .screenName)
        isClosed = try containers.decode(Int.self, forKey: .isClosed) == 1
        type = VKGroupTypes(rawValue: try containers.decode(String.self, forKey: .type))!
        isAdmin = try containers.decode(Int.self, forKey: .isAdmin) == 1
        adminLevel = VKGroupAdminLevels(rawValue: (try? containers.decode(Int.self, forKey: .isAdmin)) ?? -1)
        isMember = try containers.decode(Int.self, forKey: .isMember) == 1
        isAdvertiser = try containers.decode(Int.self, forKey: .isAdvertiser) == 1
        avatar = try VKAvatarModel(from: decoder)
        membersCount = (try? containers.decode (Int.self, forKey: .membersCount)) ?? 0
    }
    
    static func == (lhs: VKGroupModel, rhs: VKGroupModel) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.screenName == rhs.screenName &&
            lhs.isClosed == rhs.isClosed &&
            lhs.type == rhs.type &&
            lhs.isAdmin == rhs.isAdmin &&
            lhs.adminLevel == rhs.adminLevel &&
            lhs.isMember == rhs.isMember &&
            lhs.isAdvertiser == rhs.isAdvertiser &&
            lhs.avatar == rhs.avatar &&
            lhs.membersCount == rhs.membersCount
    }
    
}
