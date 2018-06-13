//
//  NewsFeedUITableViewController.swift
//  VK Community
//
//  Created by Артем on 28.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import SDWebImage

typealias NewsFeed = VKResponseModel<VKNewsFeedModel> // Тест

class NewsFeedUITableViewController: UITableViewController {
    
    var news: VKNewsFeedModel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        VKService.shared.request(method: "newsfeed.get", parameters: ["filters" : "post", "count" : "50"]) { [weak self] (response: NewsFeed) in
            self?.news = response.response
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let news = news else { return 0 }
        
        return news.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let news = self.news.items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Post") as! NewsFeedUITableViewCell
        
        cell.postId = news.postId
        cell.authorId = news.sourceId
        
        cell.postText.text = news.text
        
        setLikes(cell, news)
        
        setCommentsCount(cell, news)
        
        cell.likes = news.likes.count
        cell.likesCount.text = getShortCount(news.likes.count)
        cell.repostsCount.text = getShortCount(news.reposts.count)
        cell.viewsCount.text = getShortCount(news.views)
        
        setAuthorData(cell, news)
        
        attachmentProcessing(cell, news.attachments)
        
        return cell
    }
    
}

extension NewsFeedUITableViewController {
    
    func setLikes(_ cell: NewsFeedUITableViewCell, _ news: VKNewsModel) {
        guard news.likes.isUserLike else { return }
        
        cell.likesIcon.image = #imageLiteral(resourceName: "LikesIcon")
    }
    
    func setCommentsCount(_ cell: NewsFeedUITableViewCell, _ news: VKNewsModel) {
        guard news.comments.canPost && news.comments.count != 0 else { return }
        
        cell.commentsCount.text = getShortCount(news.comments.count)
        cell.commentsIcon.image = #imageLiteral(resourceName: "CommentsIcon")
    }
    
    func setAuthorData(_ cell: NewsFeedUITableViewCell, _ news: VKNewsModel) {
        let sourceData = getSourceData(news.sourceId)
        
        if let photoUrl = sourceData.photoUrl {
            cell.authorPhoto.sd_setImage(with: photoUrl, completed: nil)
        } else {
            cell.authorPhoto.image = news.sourceId > 0 ? #imageLiteral(resourceName: "DefaultUserPhoto") : #imageLiteral(resourceName: "DefaultGroupPhoto")
        }
        
        cell.authorName.text = sourceData.name
    }
    
    func attachmentProcessing(_ cell: NewsFeedUITableViewCell, _ attachments: [VKNewsModel.Attachments]) {
        for attachment in attachments {
            switch attachment.type {
            case "photo":
                let size = attachment.photo!.sizes.last!
                
                let url = URL(string: size.url)
                
                cell.postPhotoHeight.constant = cell.postPhoto.frame.width * CGFloat(size.height) / CGFloat(size.width)
                cell.postPhoto.sd_setImage(with: url, completed: nil)
                
                break
            default: break
            }
        }
    }
    
    func getSourceData(_ sourceId: Int) -> (name: String, photoUrl: URL?) {
        let name: String
        let photoUrl: URL?
        
        if sourceId > 0 {
            let source = self.news.profiles.filter { profile -> Bool in
                return profile.id == sourceId
                }.first!
            
            photoUrl = URL(string: source.photo100)
            name = source.firstName + " " + source.lastName
        } else {
            let source = self.news.groups.filter { group -> Bool in
                return -group.id == sourceId
                }.first!
            
            photoUrl = URL(string: source.photo100)
            name = source.name
        }
        
        return (name, photoUrl)
    }
    
}
