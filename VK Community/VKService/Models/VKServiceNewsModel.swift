//
//  VKServiceNewsModel.swift
//  VK Community
//
//  Created by Артем on 28.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import RealmSwift
import SwiftyJSON

class VKNewsList: VKBaseModel {
    
    var items: [VKNews] = []
    var profiles: [VKUser] = []
    var groups: [VKGroup] = []
    
    convenience required init(json: JSON) {
        self.init()
        items = json["items"].map({ VKNews(json: $0.1) })
        profiles = json["profiles"].map({ VKUser(json: $0.1) })
        groups = json["groups"].map({ VKGroup(json: $0.1) })
    }
    
}

class VKNews {
    
    var type = ""
    var source_id = 0
    var date = 0
    var post_id = 0
    var post_type = ""
    var text = ""
    
    var attachments: [Attachments]! = nil
    
    var comments = 0
    var likes: Likes! = nil
    var reposts = 0
    var views = 0
    
    class Likes {
        
        var count = 0
        var user_likes = 0
        
        init(_ json: JSON) {
            count = json["count"].intValue
            user_likes = json["user_likes"].intValue
        }
        
    }
        
    class Attachments {
        
        var type = ""
        var photo: Photo? = nil
        
        class Photo {
            
            var id = 0
            var sizes: [Sizes]! = nil
            
            class Sizes {
                
                var type = ""
                var url = ""
                var width = 0
                var height = 0
                
                init(_ json: JSON) {
                    type = json["type"].stringValue
                    url = json["url"].stringValue
                    width = json["width"].intValue
                    height = json["height"].intValue
                }
                
            }
            
            init(_ json: JSON) {
                id = json["id"].intValue
                sizes = json["sizes"].map({ Sizes($0.1) })
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
        
        comments = json["comments"]["count"].intValue
        likes = Likes(json["likes"])
        reposts = json["reposts"]["count"].intValue
        views = json["views"]["count"].intValue
    }
    
}
