//
//  NewsFeedUITableViewController.swift
//  VK X
//
//  Created by Artem Kufaev on 28.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit
import SDWebImage

class NewsFeedUITableViewController: UITableViewController {
  var newsFeed: VKNewsFeedModel!
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    loadNewsFeed()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let newsFeed = newsFeed else { return 0 }
    
    return newsFeed.news.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let news = self.newsFeed.news[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "Post") as! NewsFeedUITableViewCell
    
    cell.postId = news.id
    cell.authorId = news.sourceId
    
    cell.postText.isScrollEnabled = true
    cell.postText.text = news.text
    if news.text == "" {
      cell.postTextHC.constant = 0
    } else {
      cell.postTextHC.constant = cell.postText.contentSize.height
    }
    cell.postText.isScrollEnabled = false
    
    cell.setLikes(news)
    
    cell.setCommentsCount(news)
    
    cell.likesCount.text = getShortCount(news.likes.count)
    cell.repostsCount.text = getShortCount(news.reposts.count)
    cell.viewsCount.text = getShortCount(news.views.count)
    
    cell.setAuthorData(self.newsFeed, indexPath.row)
    
    cell.attachmentProcessing(news.attachments)
    
    return cell
  }
}

extension NewsFeedUITableViewController {
  func loadNewsFeed() {
    VKService.shared.request(method: "newsfeed.get", parameters: ["filters": "post", "count": "50"]) { [weak self] (response: VKNewsFeedModel) in
      guard let strongSelf = self else { return }
      strongSelf.newsFeed = response
      DispatchQueue.main.async {
        strongSelf.tableView.reloadData()
      }
    }
  }
}
