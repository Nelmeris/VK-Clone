//
//  FriendsUITableViewController.swift
//  VK Community
//
//  Created by Артем on 01.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import SDWebImage
import RealmSwift

class FriendsUITableViewController: UITableViewController, UISearchResultsUpdating {
    
    var friends: Results<VKUserModel>!
    var filteredFriends: Results<VKUserModel>!
    
    var notificationToken: NotificationToken!
    
    // Получение данных о друзьях
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        VKRequest(method: "friends.get", parameters: ["fields" : "id,photo_100,online", "order" : "hints"]) { (response: VKItemsModel<VKUserModel>) in
            let users: Results<VKUserModel> = RealmLoadData()!
            var newUsers = response.items
            
            self.saveUserPhotos(newUsers: &newUsers, users: users)
            
            RealmUpdateData(newUsers)
        }
        
//        DispatchQueue.global().async {
//            let users: Results<VKUserModel> = RealmLoadData()!
//
//            for index in 0...users.count - 1 {
//                VKRequest(method: "photos.getAll", parameters: ["owner_id": String(users[index].id)]) { (response: VKItemsModel<VKPhotoModel>) in
//                    for newPhoto in response.items {
//                        var flag = false
//                        for photo in users[index].photos {
//                            if newPhoto.isEqual(photo) {
//                                flag = true
//                                break
//                            }
//                        }
//                        if !flag {
//                            do {
//                                let realm = try Realm()
//                                realm.beginWrite()
//                                users[index].photos.append(newPhoto)
//                                try realm.commitWrite()
//                            } catch let error {
//                                print(error)
//                            }
//                        }
//                    }
//
//                    for photo in users[index].photos {
//                        var flag = false
//                        for newPhoto in response.items {
//                            if photo.isEqual(newPhoto) {
//                                flag = true
//                                break
//                            }
//                        }
//                        if !flag {
//                            RealmDeleteData([photo])
//                        }
//                    }
//                }
//                sleep(1)
//            }
//        }
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
        var cell = tableView.dequeueReusableCell(withIdentifier: "Friend") as! FriendsUITableViewCell
        
        cell.firstName.text = friend.first_name
        cell.lastName.text = friend.last_name
        
        setUserPhoto(cell: &cell, friend: friend)
        
        setStatusIcon(cell: &cell, friend: friend)
        
        return cell
    }
    
    func setUserPhoto(cell: inout FriendsUITableViewCell, friend: VKUserModel) {
        if friend.photo_100 != "" {
            cell.photo.sd_setImage(with: URL(string: friend.photo_100), completed: nil)
        } else {
            cell.photo.image = UIImage(named: "DefaultUserPhoto")
        }
    }
    
    func setStatusIcon(cell: inout FriendsUITableViewCell, friend: VKUserModel) {
        if friend.online == 1 {
            if friend.online_mobile == 1 {
                cell.onlineMobileStatusIcon.image = UIImage(named: "OnlineMobileIcon")
                cell.onlineMobileStatusIcon.layer.cornerRadius = cell.onlineStatusIcon.frame.height / 10
                cell.onlineMobileStatusIcon.backgroundColor = tableView.backgroundColor
            } else {
                cell.onlineStatusIcon.image = UIImage(named: "OnlineIcon")
                cell.onlineStatusIcon.layer.cornerRadius = cell.onlineStatusIcon.frame.height / 2
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
