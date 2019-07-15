//
//  NewsFeedTableViewController.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 28.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit
import SDWebImage

class NewsFeedTableViewController: UITableViewController {
    
    var newsFeed: VKNewsFeedModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Новости"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(newPost))
    }
    
    private let newPostSegueId = "ToNewPost"
    
    @objc func newPost() {
        performSegue(withIdentifier: newPostSegueId, sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        VKService.shared.getNewsFeed(types: [.post]) { [weak self] newsFeed in
            guard let strongSelf = self else { return }
            strongSelf.newsFeed = newsFeed
            DispatchQueue.main.async {
                strongSelf.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let newsFeed = newsFeed else { return 0 }
        
        return newsFeed.news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let news = self.newsFeed.news[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Post") as! NewsFeedTableViewCell
        
        if let postId = news.postId {
            cell.postId = postId
        }
        cell.authorId = news.sourceId
        
        if let text = news.text {
            cell.setText(text)
        }
        
        cell.setLikes(news)
        
        cell.setCommentsCount(news)
        
        if let likes = news.likes {
            cell.likesCount.text = getShortCount(likes.count)
        }
        if let reposts = news.reposts {
            cell.repostsCount.text = getShortCount(reposts.count)
        }
        if let views = news.views {
            cell.viewsCount.text = getShortCount(views.count)
        }
        
        cell.setAuthorData(self.newsFeed, indexPath.row)
        
        cell.attachmentProcessing(news.attachments)
        
        return cell
    }
}
