//
//  VKServiceNewsFeedModel.swift
//  VK Community
//
//  Created by Артем on 28.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import RealmSwift
import SwiftyJSON

class VKNewsListModel: VKBaseModel {
    
    var items: [VKNewsModel] = []
    var profiles: [VKUserModel] = []
    var groups: [VKGroupModel] = []
    
    convenience required init(json: JSON) {
        self.init()
        items = json["items"].map({ VKNewsModel(json: $0.1) })
        profiles = json["profiles"].map({ VKUserModel(json: $0.1) })
        groups = json["groups"].map({ VKGroupModel(json: $0.1) })
    }
    
}

class VKNewsModel {
    
    var type = ""
    var source_id = 0
    var date = 0
    var post_id = 0
    var post_type = ""
    var text = ""
    
    var attachments: [Attachments] = []
    
    var likes: Likes!
    class Likes {
        
        var count = 0
        var user_likes = 0
        
        init(_ json: JSON) {
            count = json["count"].intValue
            user_likes = json["user_likes"].intValue
        }
        
    }
    
    var reposts: Reposts!
    class Reposts {
        
        var count = 0
        var user_reposted = 0
        
        init(_ json: JSON) {
            count = json["count"].intValue
            user_reposted = json["user_reposted"].intValue
        }
        
    }
    
    var comments: Comments!
    class Comments {
        
        var count = 0
        var can_post = 0
        
        init(_ json: JSON) {
            count = json["count"].intValue
            can_post = json["can_post"].intValue
        }
        
    }
    
    var views = 0
        
    class Attachments {
        
        var type = ""
        var photo: Photo?
        
        class Photo {
            
            var id = 0
            var sizes: [VKSizes] = []
            
            init(_ json: JSON) {
                id = json["id"].intValue
                sizes = json["sizes"].map({ VKSizes($0.1) })
            }
            
        }
        
        init(_ json: JSON) {
            type = json["type"].stringValue
            
            switch type {
            case "photo":
                photo = Photo(json["photo"])
            default:
                break
            }
        }
        
    }
    
    init(json: JSON) {
        type = json["type"].stringValue
        source_id = json["source_id"].intValue
        date = json["date"].intValue
        post_id = json["post_id"].intValue
        post_type = json["post_type"].stringValue
        text = json["text"].stringValue
        
        attachments = json["attachments"].map({ Attachments($0.1) })
        
        comments = Comments(json["comments"])
        likes = Likes(json["likes"])
        reposts = Reposts(json["reposts"])
        views = json["views"]["count"].intValue
    }
    
}
