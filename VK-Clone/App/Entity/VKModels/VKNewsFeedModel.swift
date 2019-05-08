//
//  VKNewsFeedModel.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 28.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import Foundation
import SwiftyJSON

struct VKNewsFeedModel: Decodable {
    let news: [VKNewsModel]
    let profiles: [VKUserModel]
    let groups: [VKGroupModel]
    
    let newOffset: Int?
    let nextFrom: String?
    
    enum CodingKeys: String, CodingKey {
        case news = "items"
        case profiles, groups
        case newOffset = "new_offset"
        case nextFrom = "next_from"
    }
}


enum VKNewsTypes: String, Decodable {
    case post
    case photo, photoTag = "photo_tag"
    case wallPhoto = "wall_photo"
    case friend, note
    case audio, video
}

enum VKNewsSourceTypes: String, Decodable {
    case user, group
}

enum VKNewsPostTypes: String, Decodable {
    case post, copy
}


struct VKNewsModel: Decodable {
    let sourceId: Int
    let sourceType: VKNewsSourceTypes
    let type: VKNewsTypes
    let date: Date
    
    let postId: Int?
    let postType: VKNewsPostTypes?
    let finalPost: Bool?
    
    let copyOwnerId: Int?
    let copyPostId: Int?
    let copyHistory: Int?
    let copyPostDate: Date?
    
    let text: String?
    
    let canEdit: Bool?
    let canDelete: Bool?
    
    var attachments: [VKAttachmentModel]?
    
    let likes: VKLikesModel?
    let reposts: VKRepostsModel?
    let comments: VKCommentsModel?
    let views: VKViewsModel?
    
    enum CodingKeys: String, CodingKey {
        case sourceId = "source_id"
        case type, date, attachments
        
        case postId = "post_id"
        case postType = "post_type"
        case finalPost = "final_post"
        
        case copyOwnerId = "copy_owner_id"
        case copyPostId = "copy_post_id"
        case copyHistory = "copy_history"
        case copyPostDate = "copy_post_date"
        
        case canEdit = "can_edit"
        case canDelete = "can_delete"
        
        case text, likes, reposts, comments, views
    }
    
    init(from decoder: Decoder) throws {
        let containers = try decoder.container(keyedBy: CodingKeys.self)
        
        sourceId = try containers.decode(Int.self, forKey: .sourceId)
        sourceType = sourceId < 0 ? .group : .user
        let typeStr = try containers.decode(String.self, forKey: .type)
        type = VKNewsTypes(rawValue: typeStr)!
        let dateInt = try containers.decode(Int.self, forKey: .date)
        date = Date(timeIntervalSince1970: TimeInterval(dateInt))
        
        postId = try? containers.decode(Int.self, forKey: .postId)
        if let postTypeStr = try? containers.decode(String.self, forKey: .postType) {
            postType = postTypeStr == "post" ? .post : .copy
        } else {
            postType = nil
        }
        
        finalPost = try? containers.decode(Int.self, forKey: .finalPost) == 1
        
        copyOwnerId = try? containers.decode(Int.self, forKey: .copyOwnerId)
        copyPostId = try? containers.decode(Int.self, forKey: .copyPostId)
        copyHistory = try? containers.decode(Int.self, forKey: .copyHistory)
        if let copyPostDateInt = try? containers.decode(Int.self, forKey: .copyPostDate) {
            copyPostDate = Date(timeIntervalSince1970: TimeInterval(copyPostDateInt))
        } else {
            copyPostDate = nil
        }
        
        canEdit = try? containers.decode(Int.self, forKey: .canEdit) == 1
        canDelete = try? containers.decode(Int.self, forKey: .canDelete) == 1
        
        text = try? containers.decode(String.self, forKey: .text)
        likes = try? containers.decode(VKLikesModel.self, forKey: .likes)
        reposts = try? containers.decode(VKRepostsModel.self, forKey: .reposts)
        comments = try? containers.decode(VKCommentsModel.self, forKey: .comments)
        views = try? containers.decode(VKViewsModel.self, forKey: .views)
        
        attachments = try? containers.decode([VKAttachmentModel].self, forKey: .attachments)
    }
}





struct VKLikesModel: Decodable {
    let count: Int
    let isUserLike: Bool
    let canLike: Bool
    let canPublish: Bool
    
    enum CodingKeys: String, CodingKey {
        case count
        case isUserLike = "user_likes"
        case canLike = "can_like"
        case canPublish = "can_publish"
    }
    
    init(from decoder: Decoder) throws {
        let containers = try decoder.container(keyedBy: CodingKeys.self)
        
        count = try containers.decode(Int.self, forKey: .count)
        isUserLike = try containers.decode(Int.self, forKey: .isUserLike) == 1
        canLike = try containers.decode(Int.self, forKey: .canLike) == 1
        canPublish = try containers.decode(Int.self, forKey: .canPublish) == 1
    }
}

struct VKRepostsModel: Decodable {
    let count: Int
    let isReposted: Bool
    
    enum CodingKeys: String, CodingKey {
        case count
        case isReposted = "user_reposted"
    }
    
    init(from decoder: Decoder) throws {
        let containers = try decoder.container(keyedBy: CodingKeys.self)
        
        count = try containers.decode(Int.self, forKey: .count)
        isReposted = try containers.decode(Int.self, forKey: .isReposted) == 1
    }
}

struct VKCommentsModel: Decodable {
    let count: Int
    let canPost: Bool
    
    enum CodingKeys: String, CodingKey {
        case count
        case canPost = "can_post"
    }
    
    init(from decoder: Decoder) throws {
        let containers = try decoder.container(keyedBy: CodingKeys.self)
        
        count = try containers.decode(Int.self, forKey: .count)
        canPost = try containers.decode(Int.self, forKey: .canPost) == 1
    }
}

struct VKViewsModel: Decodable {
    let count: Int
}
