//
//  FriendsUITableViewController.swift
//  VK Community
//
//  Created by Артем on 01.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import RealmSwift

class FriendsUITableViewController: UITableViewController, UISearchResultsUpdating {
    
    var friends: Results<VKUserModel>!
    var filteredFriends: Results<VKUserModel>!
    
    var notificationToken: NotificationToken!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        VKService.methods.getFriends { data in
            RealmService.updateData(data)
        }
    }
    
    var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSearchController()
        
        friends = RealmService.loadData()!
        filteredFriends = friends
        
        RealmService.pairTableViewAndData(sender: tableView, token: &notificationToken, data: AnyRealmCollection(friends))
    }
    
    func initSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Искать..."
        
        searchController.searchBar.isTranslucent = false
        
        navigationItem.searchController = searchController
        
        definesPresentationContext = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friend = friends[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Friend") as! FriendsUITableViewCell
        
        cell.firstName.text = friend.firstName
        cell.lastName.text = friend.lastName
        
        setUserPhoto(cell, friend, indexPath)
        setStatusIcon(cell, friend)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! FriendPhotosUIViewController
        guard let indexPath = self.tableView.indexPathForSelectedRow else { return }
        
        viewController.user = (RealmService.loadData()! as Results<VKUserModel>)[indexPath.row]
        viewController.userId = viewController.user.id
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard searchController.searchBar.text != "" else {
            friends = filteredFriends
            tableView.reloadData()
            return
        }
        
        let searchText = searchController.searchBar.text!
        let array = searchText.components(separatedBy: " ")
        
        let predicate = array.count > 1 && array[1] != "" ?
            "(firstName CONTAINS[cd] '\(array[0])' AND lastName CONTAINS[cd] '\(array[1])') OR (firstName CONTAINS[cd] '\(array[1])' AND lastName CONTAINS[cd] '\(array[0])')" :
            "firstName CONTAINS[cd] '\(array[0])' OR lastName CONTAINS[cd] '\(array[0])'"
        
        friends = filteredFriends.filter(predicate)
        
        tableView.reloadData()
    }
    
    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
}



extension FriendsUITableViewController {
    
    func setUserPhoto(_ cell: FriendsUITableViewCell, _ friend: VKUserModel, _ indexPath: IndexPath) {
        guard friend.photo100 != "" else { return }
        
        let getCacheImageOperation = GetCacheImage(url: friend.photo100)
        let setImageToRowOperation = SetImageToFriendsRow(cell, indexPath, tableView)
        
        setImageToRowOperation.addDependency(getCacheImageOperation)
        
        queue.addOperation(getCacheImageOperation)
        
        OperationQueue.main.addOperation(setImageToRowOperation)
    }
    
    func setStatusIcon(_ cell: FriendsUITableViewCell, _ friend: VKUserModel) {
        guard friend.isOnline else { return }
        
        cell.onlineStatusIcon.image = friend.isOnlineMobile ? #imageLiteral(resourceName: "OnlineMobileIcon") : #imageLiteral(resourceName: "OnlineIcon")
        cell.onlineStatusIcon.backgroundColor = tableView.backgroundColor
        
        cell.onlineStatusIcon.layer.cornerRadius = cell.onlineStatusIcon.frame.height / (friend.isOnlineMobile ? 7 : 2)
        
        cell.onlineStatusIconWidth.constant = cell.photo.frame.height / (friend.isOnlineMobile ? 4.5 : 4)
        cell.onlineStatusIconHeight.constant = cell.photo.frame.height / (friend.isOnlineMobile ? 3.5 : 4)
    }
    
}

class SetImageToFriendsRow: Operation {
    private let indexPath: IndexPath
    private weak var tableView: UITableView?
    private var cell: FriendsUITableViewCell?
    
    init(_ cell: FriendsUITableViewCell, _ indexPath: IndexPath, _ tableView: UITableView) {
        self.indexPath = indexPath
        self.tableView = tableView
        self.cell = cell
    }
    
    override func main() {
        guard let tableView = tableView,
            let cell = cell,
            let getCacheImage = dependencies[0] as? GetCacheImage,
            let image = getCacheImage.outputImage else { return }
        
        if let newIndexPath = tableView.indexPath(for: cell), newIndexPath == indexPath {
            cell.photo.image = image
        } else if tableView.indexPath(for: cell) == nil {
            cell.photo.image = image
        }
    }
}
