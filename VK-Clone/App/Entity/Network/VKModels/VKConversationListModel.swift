//
//  VKConversationListModel.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 31.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import Foundation

struct VKConversationListModel: Decodable {
    let conversations: [VKConversationModel]
    let profiles: [VKUserModel]
    let groups: [VKGroupModel]
    
    let unreadCount: Int
    
    enum CodingKeys: String, CodingKey {
        case dialogs = "items"
        case profiles
        case groups
        case unreadCount = "unread_count"
    }
    
    init(from decoder: Decoder) throws {
        let containers = try decoder.container(keyedBy: CodingKeys.self)
        
        conversations = try containers.decode([VKConversationModel].self, forKey: .dialogs)
        profiles = try containers.decode([VKUserModel].self, forKey: .profiles)
        groups = try containers.decode([VKGroupModel].self, forKey: .groups)
        
        unreadCount = try containers.decode(Int.self, forKey: .unreadCount)
    }
}

class VKConversationModel: Decodable {
    let dialog: VKDialogModel
    let lastMessage: VKConversationLastMessageModel
    
    enum CodingKeys: String, CodingKey {
        case dialog
        case lastMessage = "last_message"
    }
}

class VKDialogModel: Decodable {
    let peer: VKConversationPeerModel!
    
    /// Идентификатор последнего прочтенного входящего сообщения
    let inRead: Int
    /// Идентификатор последнего прочтенного исходящего сообщения
    let outRead: Int
    let unreadCount: Int
    let important: Bool
    let unanswered: Bool
    
    enum CodingKeys: String, CodingKey {
        case peer
        case inRead = "in_read"
        case outRead = "out_read"
        case unreadCount = "unread_count"
        case important, unanswered
        case pushSettings = "push_settings"
        case canWrite = "can_write"
    }
    
    required init(from decoder: Decoder) throws {
        let containers = try decoder.container(keyedBy: CodingKeys.self)
        
        peer = try containers.decode(VKConversationPeerModel.self, forKey: .peer)
        inRead = try containers.decode(Int.self, forKey: .inRead)
        outRead = try containers.decode(Int.self, forKey: .outRead)
        unreadCount = try containers.decode(Int.self, forKey: .unreadCount)
        important = try containers.decode(Bool.self, forKey: .important)
        unanswered = try containers.decode(Bool.self, forKey: .unanswered)
    }
}

enum VKConversationPeerTypes: String, Decodable {
    case user, chat, group, email
}

class VKConversationPeerModel: Decodable {
    let id: Int
    /// Возможные значения: user, chat, group, email
    let type: VKConversationPeerTypes
    /// Локальный идентификатор назначения. Для чатов — id - 2000000000, для сообществ — -id, для e-mail — -(id+2000000000).
    let localId: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case localId = "local_id"
    }
    
    required init(from decoder: Decoder) throws {
        let containers = try decoder.container(keyedBy: CodingKeys.self)
        id = try containers.decode(Int.self, forKey: .id)
        type = VKConversationPeerTypes(rawValue: try containers.decode(String.self, forKey: .type))!
        localId = try containers.decode(Int.self, forKey: .localId)
    }
}

enum VKConversationCanWriteReasons: Int, Decodable {
    case blockOrDelete = 18
    case blackList = 900
    case blockGroupMessages = 901
    case privateSettings = 902
    case groupMessagesOff = 915
    case groupMessagesBlock = 916
    case chatNoAccess = 917
    case emailNoAccess = 918
    case groupNoAccess = 203
}

class VKConversationCanWriteModel: Decodable {
    let allowed: Bool
    let reason: VKConversationCanWriteReasons
    
    enum CodingKeys: String, CodingKey {
        case allowed
        case reason
    }
    
    required init(from decoder: Decoder) throws {
        let containers = try decoder.container(keyedBy: CodingKeys.self)
        allowed = try containers.decode(Bool.self, forKey: .allowed)
        reason = VKConversationCanWriteReasons(rawValue: try containers.decode(Int.self, forKey: .reason))!
    }
}

enum VKConversationChatSettingsStates: String, Decodable {
    case `in`, kicked, left
}

class VKConversationChatSettingsModel: Decodable {
    let membersCount: Int
    let title: String
    let pinnedMessage: VKMessageModel
    let state: VKConversationChatSettingsStates
    let photo: VKAvatarModel
    let activeIds: [Int]
    let isGroupChannel: Bool
    
    enum CodingKeys: String, CodingKey {
        case membersCount = "members_count"
        case title, state, photo
        case pinnedMessage = "pinned_message"
        case activeIds = "active_ids"
        case isGroupChannel = "is_group_channel"
    }
    
    required init(from decoder: Decoder) throws {
        let containers = try decoder.container(keyedBy: CodingKeys.self)
        membersCount = try containers.decode(Int.self, forKey: .membersCount)
        title = try containers.decode(String.self, forKey: .title)
        pinnedMessage = try containers.decode(VKMessageModel.self, forKey: .pinnedMessage)
        state = VKConversationChatSettingsStates(rawValue: try containers.decode(String.self, forKey: .state))!
        photo = try containers.decode(VKAvatarModel.self, forKey: .photo)
        activeIds = try containers.decode([Int].self, forKey: .activeIds)
        isGroupChannel = try containers.decode(Bool.self, forKey: .isGroupChannel)
    }
}

class VKConversationLastMessageModel: Decodable {
    
}
