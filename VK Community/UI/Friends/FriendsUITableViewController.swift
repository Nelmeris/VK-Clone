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
        
        loadFriends()
    }
    
    var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 75
        
        initSearchController()
        
        friends = RealmService.loadData()!
        filteredFriends = friends
        
        RealmService.pairTableViewAndData(sender: tableView, token: &notificationToken, data: AnyRealmCollection(friends))
        
        DispatchQueue.global().async {
            while true {
                self.loadFriends()
                sleep(30)
            }
        }
    }
    
    func initSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Искать..."
        
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
        
        setUserPhoto(cell, friend)
        
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
            "(first_name CONTAINS[cd] '\(array[0])' AND last_name CONTAINS[cd] '\(array[1])') OR (first_name CONTAINS[cd] '\(array[1])' AND last_name CONTAINS[cd] '\(array[0])')" :
            "first_name CONTAINS[cd] '\(array[0])' OR last_name CONTAINS[cd] '\(array[0])'"
        
        friends = filteredFriends.filter(predicate)
        
        tableView.reloadData()
    }
    
}



extension FriendsUITableViewController {
    
    func loadFriends() {
        VKService.request(method: "friends.get", parameters: ["fields" : "id,photo_100,online", "order" : "hints"]) { (response: VKItemsModel<VKUserModel>) in
            let users: Results<VKUserModel> = RealmService.loadData()!
            var newUsers = response.items
            
            self.saveUserPhotos(&newUsers, users)
            
            RealmService.updateData(newUsers)
            
            DispatchQueue.main.async {
                let users: Results<VKUserModel> = RealmService.loadData()!
                var usersIds: [Int] = []
                for user in users {
                    usersIds.append(user.id)
                }
                DispatchQueue.global().async {
                    if usersIds.count != 0 {
                        for index in 0...usersIds.count - 1 {
                            VKService.request(method: "photos.getAll", parameters: ["owner_id": String(usersIds[index])]) { (response: VKItemsModel<VKPhotoModel>) in
                                DispatchQueue.main.async {
                                    FriendPhotosUIViewController.addNewPhotos(user: users[index], newPhotos: response.items)
                                    
                                    FriendPhotosUIViewController.deleteOldPhotos(user: users[index], newPhotos: response.items)
                                }
                            }
                            sleep(3)
                        }
                    }
                }
            }
        }
    }
    
    func saveUserPhotos(_ newUsers: inout [VKUserModel], _ users: Results<VKUserModel>) {
        for newUser in newUsers {
            let newUserIndex = newUsers.index(of: newUser)!
            let newUserID = newUser.value(forKey: "id") as! Int
            for user in users {
                let userIndex = users.index(of: user)!
                let userID = user.value(forKey: "id") as! Int
                
                if newUserID == userID {
                    newUsers[newUserIndex].photos = newUsers[userIndex].photos
                    break
                }
            }
        }
    }
    
    
    
    func setUserPhoto(_ cell: FriendsUITableViewCell, _ friend: VKUserModel) {
        guard friend.photo100 != "" else { return }
        
        cell.photo.sd_setImage(with: URL(string: friend.photo100), completed: nil)
    }
    
    func setStatusIcon(_ cell: FriendsUITableViewCell, _ friend: VKUserModel) {
        guard friend.isOnline else { return }
        
        cell.onlineStatusIcon.image = friend.isOnlineMobile ? #imageLiteral(resourceName: "OnlineMobileIcon") : #imageLiteral(resourceName: "OnlineIcon")
        cell.onlineStatusIcon.backgroundColor = tableView.backgroundColor
        
        cell.onlineStatusIcon.layer.cornerRadius = cell.onlineStatusIcon.frame.height / (friend.isOnlineMobile ? 7 : 2)
        
        cell.onlineStatusIcon.constraints.filter { c -> Bool in
            return c.identifier == "Width"
            }[0].constant = cell.photo.frame.height / (friend.isOnlineMobile ? 4.5 : 4)
        
        cell.onlineStatusIcon.constraints.filter { c -> Bool in
            return c.identifier == "Height"
            }[0].constant = cell.photo.frame.height / (friend.isOnlineMobile ? 3.5 : 4)
    }
    
}
