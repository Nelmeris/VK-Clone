//
//  FriendList.swift
//  VK Community
//
//  Created by Артем on 01.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import SDWebImage
import RealmSwift

class FriendList: UITableViewController, UISearchResultsUpdating {
    
    var friends: Results<VKUser>?
    var filteredFriends: Results<VKUser>?
    
    var notificationToken: NotificationToken?
    
    // Получение данных о друзьях
    override func viewWillAppear(_ animated: Bool) {
        VKRequest(sender: self, method: .friendsGet, parameters: ["fields" : "id,photo_100,online", "order" : "hints"], completion: { (response: VKModels<VKUser>) in
            let users: Results<VKUser> = LoadData()!
            let data = response.items
            for item1 in data {
                for item2 in users {
                    if item1.value(forKey: "id") as! Int == item2.value(forKey: "id") as! Int {
                        data[data.index(of: item1)!].photos = users[users.index(of: item2)!].photos
                    }
                }
            }
            UpdatingData(data)
        })
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    // Настройки окна
    override func viewDidLoad() {
        tableView.rowHeight = 75
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Искать..."
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        friends = LoadData()
        filteredFriends = friends
        PairTableAndData(sender: tableView, token: &notificationToken, data: AnyRealmCollection(friends!))
    }
    
    // Получение количества ячеек для друзей
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends?.count ?? 0
    }
    
    // Составление ячеек для друзей
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Friend") as! FriendCell
        
        cell.firstName.text = friends?[indexPath.row].first_name ?? ""
        cell.lastName.text = friends?[indexPath.row].last_name ?? ""
        
        if friends?[indexPath.row].photo_100 != "" {
            let url = URL(string: friends![indexPath.row].photo_100)
            cell.photo.sd_setImage(with: url, completed: nil)
        } else {
            cell.photo.image = UIImage(named: "DefaultUserPhoto")
        }
        
        if friends?[indexPath.row].online == 1 {
            if friends?[indexPath.row].online_mobile == 1 {
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
        
        return cell
    }
    
    // Передача ID выбранного друга на следующий экран
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! FriendPhotoCollection
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let data = (LoadData()! as Results<VKUser>)[indexPath.row]
            vc.user = data
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
            friends = filteredFriends!.filter("(first_name CONTAINS[cd] '\(array[0])' AND last_name CONTAINS[cd] '\(array[1])') OR (first_name CONTAINS[cd] '\(array[1])' AND last_name CONTAINS[cd] '\(array[0])')")
        } else {
            friends = filteredFriends!.filter("first_name CONTAINS[cd] '\(array[0])' OR last_name CONTAINS[cd] '\(array[0])'")
        }
        
        tableView.reloadData()
    }
    
}
