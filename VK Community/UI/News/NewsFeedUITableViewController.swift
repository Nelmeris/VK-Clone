//
//  NewsFeedUITableViewController.swift
//  VK Community
//
//  Created by Артем on 28.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import SDWebImage

class NewsFeedUITableViewController: UITableViewController {
    
    var news: VKNewsListModel! = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        DispatchQueue.global().async {
            VKRequest(method: "newsfeed.get", parameters: ["filters" : "post", "count" : "50"]) { (response: VKResponseModel<VKNewsListModel>) in
                self.news = response.response
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let news = news else {
            return 0
        }
        return news.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let news = self.news.items[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "Post") as! NewsFeedUITableViewCell
        
        cell.postId = news.post_id
        cell.authorId = news.source_id
        
        cell.postText.text = news.text
        
        setLikes(cell: &cell, news: news)
        
        setCommentsCount(cell: &cell, news: news)
        
        cell.likes = news.likes.count
        cell.likesCount.text = getShortCount(news.likes.count)
        cell.repostsCount.text = getShortCount(news.reposts.count)
        cell.viewsCount.text = getShortCount(news.views)
        
        setAuthorData(cell: &cell, news: news)
        
        cell.postPhoto.constraints[0].constant = 0
        
        attachmentProcessing(cell: &cell, attachments: news.attachments)
        
        return cell
    }
    
}

extension NewsFeedUITableViewController {
    
    func setLikes(cell: inout NewsFeedUITableViewCell, news: VKNewsModel) {
        if news.likes.user_likes == 1 {
            cell.likesIcon.image = UIImage(named: "LikesIcon")
            cell.isLike = true
        }
    }
    
    func setCommentsCount(cell: inout NewsFeedUITableViewCell, news: VKNewsModel) {
        if news.comments.can_post == 0 && news.comments.count == 0 {
            cell.commentsCount.text = nil
            cell.commentsIcon.image = nil
        } else {
            cell.commentsCount.text = getShortCount(news.comments.count)
        }
    }
    
    func setAuthorData(cell: inout NewsFeedUITableViewCell, news: VKNewsModel) {
        let sourceData = getSourceData(news.source_id)
        
        if let photoUrl = sourceData.photoUrl {
            cell.authorPhoto.sd_setImage(with: photoUrl, completed: nil)
        } else {
            cell.authorPhoto.image = UIImage(named: news.source_id > 0 ? "DefaultUserPhoto" : "DefaultGroupPhoto")
        }
        
        cell.authorName.text = sourceData.name
    }
    
    func attachmentProcessing(cell: inout NewsFeedUITableViewCell, attachments: [VKNewsModel.Attachments]) {
        for attachment in attachments {
            switch attachment.type {
            case "photo":
                let size = attachment.photo!.sizes.last!
                
                let url = URL(string: size.url)
                cell.postPhoto.constraints[0].constant = cell.postPhoto.frame.width * CGFloat(size.height) / CGFloat(size.width)
                cell.postPhoto.sd_setImage(with: url, completed: nil)
                
                break
            default: break
            }
        }
    }
    
    func getSourceData(_ source_id: Int) -> (name: String, photoUrl: URL?) {
        let name: String
        let photoUrl: URL?
        
        if source_id > 0 {
            let source = self.news.profiles.filter { profile -> Bool in
                return profile.id == source_id
                }.first!
            
            photoUrl = URL(string: source.photo_100)
            name = source.first_name + " " + source.last_name
        } else {
            let source = self.news.groups.filter { group -> Bool in
                return -group.id == source_id
                }.first!
            
            photoUrl = URL(string: source.photo_100)
            name = source.name
        }
        
        return (name, photoUrl)
    }
    
}
