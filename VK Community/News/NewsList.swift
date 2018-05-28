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
        VKRequest(sender: self, method: "newsfeed.get", parameters: ["filters" : "post"]) { (response: VKResponse<VKNewsList>) in
            self.news = response.response
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Post") as! NewsCell
        
        cell.postText.text = news.items[indexPath.row].text
        cell.likesCount.text = String(news.items[indexPath.row].likes)
        cell.commentsCount.text = String(news.items[indexPath.row].comments)
        cell.repostsCount.text = String(news.items[indexPath.row].reposts)
        cell.viewsCount.text = String(news.items[indexPath.row].views)
        
        if news.items[indexPath.row].source_id > 0 {
            for item in news.profiles {
                if item.id == news.items[indexPath.row].source_id {
                    if item.photo_100 != "" {
                        let url = URL(string: item.photo_100)
                        cell.authorPhoto.sd_setImage(with: url, completed: nil)
                    } else {
                        cell.authorPhoto.image = UIImage(named: "DefaultUserPhoto")
                    }
                    cell.authorName.text = item.first_name + item.last_name
                    break
                }
            }
        } else {
            for item in news.groups {
                if item.id == -news.items[indexPath.row].source_id {
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
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let news = news else {
            return 0
        }
        return news.items.count
    }
    
}
