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
        VKRequest(sender: self, version: "5.78", method: "newsfeed.get", parameters: ["filters" : "post", "count" : "5"]) { (response: VKResponse<VKNewsList>) in
            self.news = response.response
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let news = self.news.items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Post") as! NewsCell
        
        cell.postText.text = news.text
        cell.likesCount.text = GetShortCount(news.likes.count)
        
        cell.likes = news.likes.count
        cell.postId = news.post_id
        cell.authorId = news.source_id
        
        if news.likes.user_likes == 1 {
            cell.likesIcon.image = UIImage(named: "LikesIcon")
            cell.isLike = true
        }
        
        cell.commentsCount.text = GetShortCount(news.comments)
        cell.repostsCount.text = GetShortCount(news.reposts)
        cell.viewsCount.text = GetShortCount(news.views)
        
        if news.source_id > 0 {
            for item in self.news.profiles {
                if item.id == news.source_id {
                    if item.photo_100 != "" {
                        let url = URL(string: item.photo_100)
                        cell.authorPhoto.sd_setImage(with: url, completed: nil)
                    } else {
                        cell.authorPhoto.image = UIImage(named: "DefaultUserPhoto")
                    }
                    cell.authorName.text = item.first_name + " " + item.last_name
                    break
                }
            }
        } else {
            for item in self.news.groups {
                if item.id == -news.source_id {
                    if item.photo_100 != "" {
                        let url = URL(string: item.photo_100)
                        cell.authorPhoto.sd_setImage(with: url, completed: nil)
                    } else {
                        cell.authorPhoto.image = UIImage(named: "DefaultGroupPhoto")
                    }
                    cell.authorName.text = item.name
                    break
                }
            }
        }
        
        for item in news.attachments {
            if item.type == "photo" {
                for size in item.photo!.sizes {
                    if CGFloat(size.width) > cell.postPhoto.frame.width {
                        let url = URL(string: size.url)
                        cell.postPhoto.sd_setImage(with: url!, completed: nil)
                        
                        break
                    }
                }
                
                break
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let news = news else {
            return 0
        }
        return news.items.count
    }
    
}
