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
    
    var attachments: Attachments
    
    var comments = 0
    var likes = 0
    var reposts = 0
    var views = 0
        
    class Attachments {
        
        init(_ json: JSON) {
            
        }
        
    }
    
    init(json: JSON) {
        type = json["type"].stringValue
        source_id = json["source_id"].intValue
        date = json["date"].intValue
        post_id = json["post_id"].intValue
        post_type = json["post_type"].stringValue
        text = json["text"].stringValue
        
        attachments = Attachments(json["attachments"])
        
        comments = json["comments"]["count"].intValue
        likes = json["likes"]["count"].intValue
        reposts = json["reposts"]["count"].intValue
        views = json["views"]["count"].intValue
    }
    
}
