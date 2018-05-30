//
//  NewsCell.swift
//  VK Community
//
//  Created by Артем on 28.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import Keychain

class NewsCell: UITableViewCell {
    
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
        let window = UIStoryboard(name: "Main", bundle: Bundle(for: VKAuthorization.self)).instantiateViewController(withIdentifier: "NewsFeed")
        if isLike {
            likesIcon.image = UIImage(named: "LikesOffIcon")
            isLike = false
            likes -= 1
            VKRequest(sender: window, version: "5.78", method: "likes.delete", parameters: ["type" : "post", "item_id" : String(postId), "owner_id" : String(authorId)])
        } else {
            likesIcon.image = UIImage(named: "LikesIcon")
            isLike = true
            likes += 1
            VKRequest(sender: window, version: "5.78", method: "likes.add", parameters: ["type" : "post", "item_id" : String(postId), "owner_id" : String(authorId)])
            }
            
        likesCount.text = GetShortCount(likes)
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
        
        likesIcon.image = UIImage(named: "LikesOffIcon")
        commentsIcon.image = UIImage(named: "CommentsIcon")
    }
    
}
