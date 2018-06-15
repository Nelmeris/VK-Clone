//
//  NewsFeedUITableViewController.swift
//  VK X
//
//  Created by Artem Kufaev on 28.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit
import SDWebImage

typealias NewsFeed = VKResponseModel<VKNewsFeedModel>

class NewsFeedUITableViewController: UITableViewController {
  var news: VKNewsFeedModel!
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    loadNewsFeed()
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
    
    cell.setLikes(news)
    
    cell.setCommentsCount(news)
    
    cell.likesCount.text = getShortCount(news.likes.count)
    cell.repostsCount.text = getShortCount(news.reposts.count)
    cell.viewsCount.text = getShortCount(news.views)
    
    cell.setAuthorData(self.news, indexPath.row)
    
    cell.attachmentProcessing(news.attachments)
    
    return cell
  }
}

extension NewsFeedUITableViewController {
  func loadNewsFeed() {
    VKService.shared.request(method: "newsfeed.get", parameters: ["filters": "post", "count": "50"]) { [weak self] (response: NewsFeed) in
      guard let strongSelf = self else { return }
      strongSelf.news = response.response
      DispatchQueue.main.async {
        strongSelf.tableView.reloadData()
      }
    }
  }
}
