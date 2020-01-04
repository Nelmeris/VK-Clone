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
    func configure(with viewModel: NewsViewModel) {
        if let postId = viewModel.postId {
            self.postId = postId
        }
        self.authorId = viewModel.author.id
        
        if let text = viewModel.text {
            setText(text)
        }
        if let likes = viewModel.likes {
            setLikes(likes);
        }
        
        if let comments = viewModel.comments {
            setCommentsCount(comments)
        }
        
        if let likes = viewModel.likes {
            likesCount.text = getShortCount(likes.count)
        }
        if let reposts = viewModel.repostsCount {
            repostsCount.text = getShortCount(reposts)
        }
        if let views = viewModel.viewsCount {
            viewsCount.text = getShortCount(views)
        }
        
        self.setAuthorData(with: viewModel.author)
        
        viewModel.attachments?.forEach(attachmentProcessing);
    }
    
    private func setText(_ text: String) {
        postText.isScrollEnabled = true
        postText.text = text
        if text == "" {
            postTextHC.constant = 0
        } else {
            postTextHC.constant = postText.contentSize.height
        }
        postText.isScrollEnabled = false
    }
    
    private func setLikes(_ likes: VKLikesModel) {
        guard likes.isUserLike else { return }
        
        likesIcon.image = #imageLiteral(resourceName: "LikesIcon")
    }
    
    private func setCommentsCount(_ comments: VKCommentsModel) {
        guard comments.canPost && comments.count != 0 else { return }
        
        commentsCount.text = getShortCount(comments.count)
        commentsIcon.image = #imageLiteral(resourceName: "CommentsIcon")
    }
    
    private func setAuthorData(with sourceData: (id: Int, name: String, photoUrl: URL?)) {
        if let photoUrl = sourceData.photoUrl {
            authorPhoto.sd_setImage(with: photoUrl, completed: nil)
        } else {
            authorPhoto.image = (sourceData.id > 0 ? #imageLiteral(resourceName: "DefaultUserPhoto") : #imageLiteral(resourceName: "DefaultGroupPhoto"))
        }
        
        authorName.text = sourceData.name
    }
    
    func attachmentProcessing(_ attachment: VKAttachmentModel) {
        switch attachment.type {
        case .photo:
            let size = (attachment.attachment as! VKPhotoModel).sizes.last!
            
            postPhotoHeight.constant = (frame.width - 30) * CGFloat(size.height) / CGFloat(size.width)
            postPhoto.sd_setImage(with: size.url, completed: nil)
            
        default: break
        }
    }
}
