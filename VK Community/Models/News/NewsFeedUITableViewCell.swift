//
//  NewsFeedUITableViewCell.swift
//  VK Community
//
//  Created by Артем on 28.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import Keychain

class NewsFeedUITableViewCell: UITableViewCell {
    
    @IBOutlet weak var authorPhoto: UIImageView! {
        didSet {
            authorPhoto.layer.cornerRadius = authorPhoto.frame.height / 2
        }
    }
    var authorId = 0
    var postId = 0
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var postText: UILabel!
    var likes = 0
    @IBOutlet weak var likesCount: UILabel!
    @IBOutlet weak var repostsCount: UILabel!
    @IBOutlet weak var commentsCount: UILabel!
    @IBOutlet weak var viewsCount: UILabel!
    @IBOutlet weak var postPhoto: UIImageView!
    
    var isLike = false
    @IBOutlet weak var likesIcon: UIImageView!
    
    @IBOutlet weak var commentsIcon: UIImageView!
    
    @IBAction func LikesClick(_ sender: Any) {
        let parameters = ["type" : "post", "item_id" : String(postId), "owner_id" : String(authorId)]
        
        if isLike {
            likesIcon.image = #imageLiteral(resourceName: "LikesOffIcon")
            isLike = false
            likes -= 1
            VKService.request(method: "likes.delete", parameters: parameters)
        } else {
            likesIcon.image = #imageLiteral(resourceName: "LikesIcon")
            isLike = true
            likes += 1
            VKService.request(method: "likes.add", parameters: parameters)
        }
            
        likesCount.text = getShortCount(likes)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        authorName.text = ""
        likesCount.text = ""
        repostsCount.text = ""
        commentsCount.text = ""
        viewsCount.text = ""
        
        postPhoto.image = nil
        postPhoto.constraints[0].constant = 0
        authorPhoto.image = nil
        
        likesIcon.image = #imageLiteral(resourceName: "LikesOffIcon")
        commentsIcon.image = #imageLiteral(resourceName: "LikesIcon")
    }
    
}
