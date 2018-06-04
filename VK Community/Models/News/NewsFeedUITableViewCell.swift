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
    
    var authorId = 0
    var postId = 0
    var likes = 0
    
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var authorPhoto: UIImageView! {
        didSet {
            authorPhoto.layer.cornerRadius = authorPhoto.frame.height / 2
        }
    }
    
    @IBOutlet weak var postText: UILabel!
    
    @IBOutlet weak var likesCount: UILabel!
    @IBOutlet weak var repostsCount: UILabel!
    @IBOutlet weak var commentsCount: UILabel! {
        didSet {
            commentsCount.text = nil
        }
    }
    @IBOutlet weak var viewsCount: UILabel!
    
    @IBOutlet weak var postPhoto: UIImageView! {
        didSet {
            postPhoto.constraints.filter { c -> Bool in
                return c.identifier == "Height"
                }[0].constant = 0
        }
    }
    
    @IBOutlet weak var likesIcon: UIImageView! {
        didSet {
            likesIcon.image = #imageLiteral(resourceName: "LikesOffIcon")
        }
    }
    @IBOutlet weak var commentsIcon: UIImageView! {
        didSet {
            commentsIcon.image = nil
        }
    }
    
    @IBAction func LikesClick(_ sender: Any) {
        let parameters = ["type" : "post", "item_id" : String(postId), "owner_id" : String(authorId)]
        
        if likesIcon.image == #imageLiteral(resourceName: "LikesIcon") {
            likesIcon.image = #imageLiteral(resourceName: "LikesOffIcon")
            likes -= 1
            VKService.request(method: "likes.delete", parameters: parameters)
        } else {
            likesIcon.image = #imageLiteral(resourceName: "LikesIcon")
            likes += 1
            VKService.request(method: "likes.add", parameters: parameters)
        }
            
        likesCount.text = getShortCount(likes)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        authorName.text = nil
        likesCount.text = nil
        repostsCount.text = nil
        commentsCount.text = nil
        viewsCount.text = nil
        
        postPhoto.constraints.filter { c -> Bool in
            return c.identifier == "Height"
            }[0].constant = 0
        authorPhoto.image = nil
        
        likesIcon.image = #imageLiteral(resourceName: "LikesOffIcon")
        commentsIcon.image = nil
    }
    
}
