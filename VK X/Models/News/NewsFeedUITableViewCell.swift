//
//  NewsFeedUITableViewCell.swift
//  VK X
//
//  Created by Artem Kufaev on 28.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit
import Keychain

class NewsFeedUITableViewCell: UITableViewCell {
  var authorId = 0
  var postId = 0
  
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
  
  @IBOutlet weak var postPhoto: UIImageView!
  
  @IBOutlet weak var postPhotoHeight: NSLayoutConstraint! {
    didSet {
      postPhotoHeight.constant = 0
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
    let isLike = likesIcon.image == #imageLiteral(resourceName: "LikesIcon")
    
    likesIcon.image = (isLike ? #imageLiteral(resourceName: "LikesOffIcon") : #imageLiteral(resourceName: "LikesIcon"))
    
    let parameters = ["type": "post", "item_id": String(postId), "owner_id": String(authorId)]
    VKService.shared.request(method: "likes." + (isLike ? "delete" : "add"), parameters: parameters)
    
    guard let likes = Int(likesCount.text!) else { return }
    
    likesCount.text = getShortCount(isLike ? likes - 1 : likes + 1)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    authorName.text = nil
    likesCount.text = nil
    repostsCount.text = nil
    commentsCount.text = nil
    viewsCount.text = nil
    
    postPhotoHeight.constant = 0
    authorPhoto.image = nil
    
    likesIcon.image = #imageLiteral(resourceName: "LikesOffIcon")
    commentsIcon.image = nil
  }
}

extension NewsFeedUITableViewCell {
  func setLikes(_ news: VKNewsModel) {
    guard news.likes.isUserLike else { return }
    
    likesIcon.image = #imageLiteral(resourceName: "LikesIcon")
  }
  
  func setCommentsCount(_ news: VKNewsModel) {
    guard news.comments.canPost && news.comments.count != 0 else { return }
    
    commentsCount.text = getShortCount(news.comments.count)
    commentsIcon.image = #imageLiteral(resourceName: "CommentsIcon")
  }
  
  func setAuthorData(_ news: VKNewsFeedModel, _ newsIndex: Int) {
    let sourceData = getSourceData(news, newsIndex)
    
    if let photoUrl = sourceData.photoUrl {
      authorPhoto.sd_setImage(with: photoUrl, completed: nil)
    } else {
      authorPhoto.image = (news.items[newsIndex].sourceId > 0 ? #imageLiteral(resourceName: "DefaultUserPhoto") : #imageLiteral(resourceName: "DefaultGroupPhoto"))
    }
    
    authorName.text = sourceData.name
  }
  
  func attachmentProcessing(_ attachments: [VKNewsModel.Attachments]) {
    for attachment in attachments {
      switch attachment.type {
      case "photo":
        let size = attachment.photo!.sizes.last!
        
        postPhotoHeight.constant = postPhoto.frame.width * CGFloat(size.height) / CGFloat(size.width)
        postPhoto.sd_setImage(with: URL(string: size.url), completed: nil)
        
      default: break
      }
    }
  }
  
  func getSourceData(_ news: VKNewsFeedModel, _ newsIndex: Int) -> (name: String, photoUrl: URL?) {
    let name: String
    let photoUrl: URL?
    
    if news.items[newsIndex].sourceId > 0 {
      let source = news.profiles.filter { profile -> Bool in
        profile.id == news.items[newsIndex].sourceId
        }.first!
      
      photoUrl = URL(string: source.photo100)
      name = source.firstName + " " + source.lastName
    } else {
      let source = news.groups.filter { group -> Bool in
        -group.id == news.items[newsIndex].sourceId
        }.first!
      
      photoUrl = URL(string: source.photo100)
      name = source.name
    }
    
    return (name, photoUrl)
  }
}
