//
//  FriendsTableViewController.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 01.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit

class FriendsTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var displayedFriends = [VKUserModel]()
    var friends = [VKUserModel]()
    
    var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Друзья"
        
        configureSearchController()
        self.tableView.rowHeight = 55.0
        
        VKService.shared.getFriends { [weak self] newFriends in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.displayedFriends = newFriends
                strongSelf.friends = newFriends
                strongSelf.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        VKService.shared.getFriends { [weak self] newFriends in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.tableView.beginUpdates()
                strongSelf.tableView.updateData(data: strongSelf.friends, newData: newFriends)
                strongSelf.displayedFriends = newFriends
                strongSelf.friends = newFriends
                strongSelf.tableView.endUpdates()
            }
        }
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Искать..."
        searchController.searchBar.isTranslucent = false
        
        navigationItem.searchController = searchController
        
        definesPresentationContext = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedFriends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friend = displayedFriends[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Friend") as! FriendsTableViewCell
        
        cell.name.text = friend.firstName + " " + friend.lastName
        
        cell.setPhoto(friend.avatar.photo100.absoluteString)
        cell.onlineStatusIcon.initial(friend.isOnline, friend.isOnlineMobile, cell.photo.frame, tableView.backgroundColor!)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! FriendPhotosViewController
        guard let indexPath = self.tableView.indexPathForSelectedRow else { return }
        
        viewController.user = displayedFriends[indexPath.row]
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text,
            !searchText.isEmpty else {
            self.tableView.beginUpdates()
            self.tableView.updateData(data: self.displayedFriends, newData: self.friends, with: .none)
            displayedFriends = friends
            self.tableView.endUpdates()
            return
        }
        
        self.tableView.beginUpdates()
        let oldFriends = displayedFriends
        displayedFriends = friends.filter({ friend -> Bool in
            return friend.fullName.lowercased().contains(searchText.lowercased())
        })
        self.tableView.updateData(data: oldFriends, newData: displayedFriends, with: .none)
        self.tableView.endUpdates()
    }
}
