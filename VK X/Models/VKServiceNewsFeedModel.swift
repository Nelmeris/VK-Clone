//
//  VKServiceNewsFeedModel.swift
//  VK X
//
//  Created by Artem Kufaev on 28.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

struct VKNewsFeedModel: Decodable {
  var news: [VKNewsModel]
  var profiles: [VKUserModel]
  var groups: [VKGroupModel]
  
  enum CodingKeys: String, CodingKey {
    case news = "items"
    case profiles, groups
  }
  
  init(from decoder: Decoder) throws {
    let containers = try decoder.container(keyedBy: CodingKeys.self)
    
    news = try containers.decode([VKNewsModel].self, forKey: .news)
    profiles = try containers.decode([VKUserModel].self, forKey: .profiles)
    groups = try containers.decode([VKGroupModel].self, forKey: .groups)
  }
}



struct VKNewsModel: Decodable {
  var id: Int
  var type: String
  var date: Int
  /// ID автора
  var sourceId: Int
  var text: String
  
  /// Вложения
  var attachments: [VKAttachmentModel]
  
  var likes: VKLikesModel
  var reposts: VKRepostsModel
  var comments: VKCommentsModel
  var views: VKViewsModel
  
  enum CodingKeys: String, CodingKey {
    case id = "post_id"
    case sourceId = "source_id"
    case type, date, text, attachments, likes, reposts, comments, views
  }
  
  init(from decoder: Decoder) throws {
    let containers = try decoder.container(keyedBy: CodingKeys.self)
    
    id = try containers.decode(Int.self, forKey: .id)
    type = try containers.decode(String.self, forKey: .type)
    date = try containers.decode(Int.self, forKey: .date)
    sourceId = try containers.decode(Int.self, forKey: .sourceId)
    text = try containers.decode(String.self, forKey: .text)
    
    attachments = try containers.decode([VKAttachmentModel].self, forKey: .attachments)
    
    likes = try containers.decode(VKLikesModel.self, forKey: .likes)
    reposts = try containers.decode(VKRepostsModel.self, forKey: .reposts)
    comments = try containers.decode(VKCommentsModel.self, forKey: .comments)
    views = try containers.decode(VKViewsModel.self, forKey: .views)
  }
}



struct VKAttachmentModel: Decodable {
  var type: String
  var photo: VKPhotoModel?
}



struct VKLikesModel: Decodable {
  var count: Int
  var isUserLike: Bool
  
  enum CodingKeys: String, CodingKey {
    case count
    case isUserLike = "user_likes"
  }
  
  init(from decoder: Decoder) throws {
    let containers = try decoder.container(keyedBy: CodingKeys.self)
    
    count = try containers.decode(Int.self, forKey: .count)
    isUserLike = try containers.decode(Int.self, forKey: .isUserLike) == 1
  }
}

struct VKRepostsModel: Decodable {
  var count: Int
  var canReposted: Bool
  
  enum CodingKeys: String, CodingKey {
    case count
    case canReposted = "can_reposted"
  }
  
  init(from decoder: Decoder) throws {
    let containers = try decoder.container(keyedBy: CodingKeys.self)
    
    count = try containers.decode(Int.self, forKey: .count)
    canReposted = (try? containers.decode(Int.self, forKey: .canReposted) == 1) ?? false
  }
}

struct VKCommentsModel: Decodable {
  var count: Int
  var canComment: Bool
  
  enum CodingKeys: String, CodingKey {
    case count
    case canComment = "can_post"
  }
  
  init(from decoder: Decoder) throws {
    let containers = try decoder.container(keyedBy: CodingKeys.self)
    
    count = try containers.decode(Int.self, forKey: .count)
    canComment = try containers.decode(Int.self, forKey: .canComment) == 1
  }
}

struct VKViewsModel: Decodable {
  var count: Int
}
