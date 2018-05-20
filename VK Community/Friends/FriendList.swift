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
    
    // Получение данных о друзьях
    override func viewWillAppear(_ animated: Bool) {
        VKRequest(sender: self, method: .friendsGet, parameters: ["fields" : "id,photo_100,online", "order" : "hints"], completion: { [weak self] (response: VKModels<VKUser>) in
            UpdatingData(response.items)
            self?.tableView.reloadData()
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
    }
    
    // Получение количества ячеек для друзей
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = LoadData()! as Results<VKUser>
        return data.count
    }
    
    // Составление ячеек для друзей
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = (LoadData()! as Results<VKUser>)[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Friend") as! FriendCell
        
        cell.firstName.text = data.first_name
        cell.lastName.text = data.last_name
        
        guard data.photo_100 != "" else {
            cell.photo.image = UIImage(named: "DefaultUserPhoto")
            return cell
        }
        
        let url = URL(string: data.photo_100)
        cell.photo.sd_setImage(with: url, completed: nil)
        
        if data.online == 1 {
            if data.online_mobile == 1 {
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
//        let searchText = searchController.searchBar.text!
//        
//        guard searchController.searchBar.text != "" else {
//            currentFriends = friends
//            tableView.reloadData()
//            return
//        }
//        
//        currentFriends = friends.filter({ friend -> Bool in
//            let fullName: String = friend.first_name + " " + friend.last_name
//            return fullName.lowercased().contains(searchText.lowercased())
//        })
//        
//        tableView.reloadData()
    }
    
}
