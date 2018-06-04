//
//  VKServiceNewsFeedModel.swift
//  VK Community
//
//  Created by Артем on 28.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import RealmSwift
import SwiftyJSON

class VKNewsFeedModel: VKBaseModel {
    
    var items: [VKNewsModel] = []
    var profiles: [VKUserModel] = []
    var groups: [VKGroupModel] = []
    
    required convenience init(_ json: JSON) {
        self.init()
        
        items = json["items"].map({ VKNewsModel($0.1) })
        profiles = json["profiles"].map({ VKUserModel($0.1) })
        groups = json["groups"].map({ VKGroupModel($0.1) })
    }
    
}

class VKNewsModel {
    
    var type = ""
    var sourceId = 0
    var date = 0
    var postId = 0
    var text = ""
    
    var attachments: [Attachments] = []
    
    var likes: Likes!
    class Likes {
        
        var count = 0
        var isUserLike = false
        
        init(_ json: JSON) {
            count = json["count"].intValue
            isUserLike = json["user_likes"].intValue == 0 ? false : true
        }
        
    }
    
    var reposts: Reposts!
    class Reposts {
        
        var count = 0
        var canReposted = false
        
        init(_ json: JSON) {
            count = json["count"].intValue
            canReposted = json["user_reposted"].intValue == 0 ? false : true
        }
        
    }
    
    var comments: Comments!
    class Comments {
        
        var count = 0
        var canPost = false
        
        init(_ json: JSON) {
            count = json["count"].intValue
            canPost = json["can_post"].intValue == 0 ? false : true
        }
        
    }
    
    var views = 0
        
    class Attachments {
        
        var type = ""
        var photo: VKPhotoModel?
        
        init(_ json: JSON) {
            type = json["type"].stringValue
            
            switch type {
            case "photo":
                photo = VKPhotoModel(json["photo"])
            default:
                break
            }
        }
        
    }
    
    init(_ json: JSON) {
        type = json["type"].stringValue
        sourceId = json["source_id"].intValue
        date = json["date"].intValue
        postId = json["post_id"].intValue
        text = json["text"].stringValue
        
        attachments = json["attachments"].map({ Attachments($0.1) })
        
        comments = Comments(json["comments"])
        likes = Likes(json["likes"])
        reposts = Reposts(json["reposts"])
        views = json["views"]["count"].intValue
    }
    
}
