//
//  NewsFeedTableViewCell.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 28.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit
import Keychain

class NewsFeedTableViewCell: UITableViewCell {
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var authorPhoto: RoundImageView!
    
    @IBOutlet weak var postText: UITextView! {
        didSet {
            postText.textContainer.lineFragmentPadding = 0
        }
    }
    @IBOutlet weak var postTextHC: NSLayoutConstraint!
    
    @IBOutlet weak var likesCount: UILabel!
    @IBOutlet weak var repostsCount: UILabel!
    @IBOutlet weak var commentsCount: UILabel!
    @IBOutlet weak var viewsCount: UILabel!
    
    @IBOutlet weak var postPhoto: UIImageView!
    
    @IBOutlet weak var postPhotoHeight: NSLayoutConstraint!
    
    @IBOutlet weak var likesIcon: UIImageView!
    @IBOutlet weak var commentsIcon: UIImageView!
    
    var authorId = 0
    var postId = 0
    
    override func awakeFromNib() {
        commentsIcon.image = nil
        commentsCount.text = nil
        likesIcon.image = #imageLiteral(resourceName: "LikesOffIcon")
        postPhotoHeight.constant = 0
    }
    
    func setText(_ text: String) {
        postText.isScrollEnabled = true
        postText.text = text
        if text == "" {
            postTextHC.constant = 0
        } else {
            postTextHC.constant = postText.contentSize.height
        }
        postText.isScrollEnabled = false
    }
    
    @IBAction func LikesClick(_ sender: Any) {
        let isLike = likesIcon.image == #imageLiteral(resourceName: "LikesIcon")
        
        likesIcon.image = (isLike ? #imageLiteral(resourceName: "LikesOffIcon") : #imageLiteral(resourceName: "LikesIcon"))
        
        if isLike {
            VKService.shared.deleteLike(type: .post, itemId: postId, authorId: authorId)
        } else {
            VKService.shared.addLike(type: .post, itemId: postId, authorId: authorId)
        }
        
        guard let likes = Int(likesCount.text!) else { return }
        
        likesCount.text = getShortCount(likes + (isLike ? -1 : 1))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        commentsCount.text = nil
        commentsIcon.image = nil
        
        postPhotoHeight.constant = 0
        authorPhoto.image = nil
        
        likesIcon.image = #imageLiteral(resourceName: "LikesOffIcon")
    }
}

extension NewsFeedTableViewCell {
    func setLikes(_ news: VKNewsModel) {
        guard let likes = news.likes, likes.isUserLike else { return }
        
        likesIcon.image = #imageLiteral(resourceName: "LikesIcon")
    }
    
    func setCommentsCount(_ news: VKNewsModel) {
        guard let comments = news.comments, comments.canPost && comments.count != 0 else { return }
        
        commentsCount.text = getShortCount(comments.count)
        commentsIcon.image = #imageLiteral(resourceName: "CommentsIcon")
    }
    
    func setAuthorData(_ newsFeed: VKNewsFeedModel, _ newsIndex: Int) {
        let sourceData = getSourceData(newsFeed, newsIndex)
        
        if let photoUrl = sourceData.photoUrl {
            authorPhoto.sd_setImage(with: photoUrl, completed: nil)
        } else {
            authorPhoto.image = (newsFeed.news[newsIndex].sourceId > 0 ? #imageLiteral(resourceName: "DefaultUserPhoto") : #imageLiteral(resourceName: "DefaultGroupPhoto"))
        }
        
        authorName.text = sourceData.name
    }
    
    func attachmentProcessing(_ attachments: [VKAttachmentModel]?) {
        guard let attachments = attachments else {
            return
        }
        for attachment in attachments {
            switch attachment.type {
            case .photo:
                let size = (attachment.attachment as! VKPhotoModel).sizes.last!
                
                postPhotoHeight.constant = (frame.width - 30) * CGFloat(size.height) / CGFloat(size.width)
                postPhoto.sd_setImage(with: size.url, completed: nil)
                
            default: break
            }
        }
    }
    
    func getSourceData(_ newsFeed: VKNewsFeedModel, _ newsIndex: Int) -> (name: String, photoUrl: URL?) {
        let name: String
        let photoUrl: URL?
        
        if newsFeed.news[newsIndex].sourceId > 0 {
            let source = newsFeed.profiles.filter { profile -> Bool in
                profile.id == newsFeed.news[newsIndex].sourceId
                }.first!
            
            photoUrl = source.avatar.photo100
            name = source.firstName + " " + source.lastName
        } else {
            let source = newsFeed.groups.filter { group -> Bool in
                -group.id == newsFeed.news[newsIndex].sourceId
                }.first!
            
            photoUrl = source.avatar.photo100
            name = source.name
        }
        
        return (name, photoUrl)
    }
}
