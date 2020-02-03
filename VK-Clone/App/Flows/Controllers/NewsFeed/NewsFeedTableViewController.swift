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
    
    var viewModels: [NewsViewModel]!
    
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
        
        VKServiceNewsFeedLoggerProxy().getNewsFeed(types: [.post]) { [weak self] newsFeed in
            guard let strongSelf = self else { return }
            strongSelf.viewModels = NewsViewModelFactory().constructViewModels(from: newsFeed)
            
            DispatchQueue.main.async {
                strongSelf.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.viewModels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Post") as! NewsFeedTableViewCell
        cell.configure(with: model)
        return cell
    }
}
