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
    
    // Получение данных о друзьях
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        loadFriends()
    }
    
    func loadFriends() {
        VKRequest(method: "friends.get", parameters: ["fields" : "id,photo_100,online", "order" : "hints"]) { (response: VKItemsModel<VKUserModel>) in
            let users: Results<VKUserModel> = RealmLoadData()!
            var newUsers = response.items
            
            self.saveUserPhotos(newUsers: &newUsers, users: users)
            
            RealmUpdateData(newUsers)
            
            DispatchQueue.main.async {
                let users: Results<VKUserModel> = RealmLoadData()!
                var usersIds: [Int] = []
                for user in users {
                    usersIds.append(user.id)
                }
                DispatchQueue.global().async {
                    if usersIds.count != 0 {
                        for index in 0...usersIds.count - 1 {
                            VKRequest(method: "photos.getAll", parameters: ["owner_id": String(usersIds[index])]) { (response: VKItemsModel<VKPhotoModel>) in
                                DispatchQueue.main.async {
                                    addNewPhotos(user: users[index], newPhotos: response.items)
                                    
                                    deleteOldPhotos(user: users[index], newPhotos: response.items)
                                }
                            }
                            sleep(3)
                        }
                    }
                }
            }
        }
    }
    
    // Сохранение фото
    func saveUserPhotos(newUsers: inout [VKUserModel], users: Results<VKUserModel>) {
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
    
    var searchController = UISearchController(searchResultsController: nil)
    
    // Настройки окна
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 75
        
        initSearchController()
        
        friends = RealmLoadData()!
        filteredFriends = friends
        
        PairTableAndData(sender: tableView, token: &notificationToken, data: AnyRealmCollection(friends))
        
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
    
    // Получение количества ячеек для друзей
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    // Составление ячеек для друзей
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friend = friends[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Friend") as! FriendsUITableViewCell
        
        cell.firstName.text = friend.first_name
        cell.lastName.text = friend.last_name
        
        setUserPhoto(cell: cell, friend: friend)
        
        setStatusIcon(cell: cell, friend: friend)
        
        return cell
    }
    
    func setUserPhoto(cell: FriendsUITableViewCell, friend: VKUserModel) {
        if friend.photo_100 != "" {
            cell.photo.sd_setImage(with: URL(string: friend.photo_100), completed: nil)
        } else {
            cell.photo.image = UIImage(named: "DefaultUserPhoto")
        }
    }
    
    func setStatusIcon(cell: FriendsUITableViewCell, friend: VKUserModel) {
        if friend.online == 1 {
            if friend.online_mobile == 1 {
                cell.onlineMobileStatusIcon.image = UIImage(named: "OnlineMobileIcon")
                cell.onlineMobileStatusIcon.backgroundColor = tableView.backgroundColor
            } else {
                cell.onlineStatusIcon.image = UIImage(named: "OnlineIcon")
                cell.onlineStatusIcon.backgroundColor = tableView.backgroundColor
            }
        } else {
            cell.onlineStatusIcon.image = nil
            cell.onlineStatusIcon.backgroundColor = UIColor.clear
        }
    }
    
    // Передача ID выбранного друга на следующий экран
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! FriendPhotosUIViewController
        if let indexPath = self.tableView.indexPathForSelectedRow {
            viewController.user = (RealmLoadData()! as Results<VKUserModel>)[indexPath.row]
            viewController.userId = viewController.user.id
        }
    }
    
    // Реализация поиска
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        let array = searchText.components(separatedBy: " ")
        
        guard searchController.searchBar.text != "" else {
            friends = filteredFriends
            tableView.reloadData()
            return
        }
        
        if array.count > 1 && array[1] != "" {
            friends = filteredFriends.filter("(first_name CONTAINS[cd] '\(array[0])' AND last_name CONTAINS[cd] '\(array[1])') OR (first_name CONTAINS[cd] '\(array[1])' AND last_name CONTAINS[cd] '\(array[0])')")
        } else {
            friends = filteredFriends.filter("first_name CONTAINS[cd] '\(array[0])' OR last_name CONTAINS[cd] '\(array[0])'")
        }
        
        tableView.reloadData()
    }
    
}
