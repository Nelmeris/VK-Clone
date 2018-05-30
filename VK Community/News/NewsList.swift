//
//  NewsList.swift
//  VK Community
//
//  Created by Артем on 28.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import SDWebImage

class NewsList: UITableViewController {
    
    var news: VKNewsList! = nil
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.global().async {
            VKRequest(sender: self, version: "5.78", method: "newsfeed.get", parameters: ["filters" : "post", "count" : "50"]) { (response: VKResponse<VKNewsList>) in
                self.news = response.response
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let news = self.news.items[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "Post") as! NewsCell
        
        cell.postId = news.post_id
        cell.authorId = news.source_id
        
        cell.postText.text = news.text
        
        if news.likes.user_likes == 1 {
            cell.likesIcon.image = UIImage(named: "LikesIcon")
            cell.isLike = true
        }
        
        if news.comments.can_post == 0 && news.comments.count == 0 {
            cell.commentsCount.text = nil
            cell.commentsIcon.image = nil
        } else {
            cell.commentsCount.text = GetShortCount(news.comments.count)
        }
        
        cell.likes = news.likes.count
        cell.likesCount.text = GetShortCount(news.likes.count)
        cell.repostsCount.text = GetShortCount(news.reposts.count)
        cell.viewsCount.text = GetShortCount(news.views)
        
        let sourceData = GetSourceData(news.source_id)
        
        if let photoUrl = sourceData.photoUrl {
            cell.authorPhoto.sd_setImage(with: photoUrl, completed: nil)
        } else {
            cell.authorPhoto.image = UIImage(named: news.source_id > 0 ? "DefaultUserPhoto" : "DefaultGroupPhoto")
        }
        
        cell.authorName.text = sourceData.name
        
        cell.postPhoto.constraints[0].constant = 0
        
        AttachmentProcessing(cell: &cell, attachments: news.attachments)
        
        return cell
    }
    
    func AttachmentProcessing(cell: inout NewsCell, attachments: [VKNews.Attachments]) {
        for attachment in attachments {
            if attachment.type == "photo" {
                let size = attachment.photo!.sizes.last!
                
                let url = URL(string: size.url)
                cell.postPhoto.constraints[0].constant = cell.postPhoto.frame.width * CGFloat(size.height) / CGFloat(size.width)
                cell.postPhoto.sd_setImage(with: url, completed: nil)
                
                break
            }
        }
    }
    
    func GetSourceData(_ source_id: Int) -> (name: String, photoUrl: URL?) {
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let news = news else {
            return 0
        }
        return news.items.count
    }
    
}
