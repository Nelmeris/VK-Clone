//
//  FriendList.swift
//  VK Community
//
//  Created by Артем on 01.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import SDWebImage
import VKService
import RealmSwift

class FriendList: UITableViewController, UISearchResultsUpdating {
    
    // Получение данных о друзьях
    override func viewWillAppear(_ animated: Bool) {
        Request(sender: self, method: .friendsGet, parameters: ["fields" : "id,photo_100,online", "order" : "hints"], completion: { [weak self] (response: [User]) in
            SaveData(response)
            self?.tableView.reloadData()
        })
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    // Настройки окна
    override func viewDidLoad() {
        SaveData([User]())
        
        tableView.rowHeight = 75
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Искать..."
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    // Получение количества ячеек для друзей
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LoadData(User())!.count
    }
    
    // Составление ячеек для друзей
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Friend") as! FriendCell
        
        cell.firstName.text = LoadData(User())![indexPath.row].first_name
        cell.lastName.text = LoadData(User())![indexPath.row].last_name
        
        guard LoadData(User())![indexPath.row].photo_100 != "" else {
            cell.photo.image = UIImage(named: "DefaultUserPhoto")
            return cell
        }
        
        let url = URL(string: LoadData(User())![indexPath.row].photo_100)
        cell.photo.sd_setImage(with: url, completed: nil)
        
        if LoadData(User())![indexPath.row].online == 1 {
            if LoadData(User())![indexPath.row].online_mobile == 1 {
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
            vc.user = LoadData(User())![indexPath.row]
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
