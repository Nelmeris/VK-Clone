//
//  GroupSearchList.swift
//  VK Community
//
//  Created by Артем on 03.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import RealmSwift

class SearchGroupList: UITableViewController, UISearchResultsUpdating {
    
    var groups = [VKGroup]()
    
    override func viewWillAppear(_ animated: Bool) {
        groups.removeAll()
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    //Настройка окна
    override func viewDidLoad() {
        tableView.rowHeight = 75
        
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск..."
        navigationItem.searchController = searchController
    }
    
    // Получение количества ячеек для результата поиска
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    // Составление ячеек для результата поиска
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Group", for: indexPath) as! GroupCell
        
        cell.name.text = groups[indexPath.row].name
        
        let url = URL(string: groups[indexPath.row].photo_100)
        cell.photo.sd_setImage(with: url, completed: nil)
        
        switch groups[indexPath.row].members_count {
        case let x where x >= 1000000:
            cell.participantsCount.text = String(format: "%.1f", Double(x) / 1000000) + "М"
            break
        case let x where x >= 1000:
            cell.participantsCount.text = String(format: "%.1f", Double(x) / 1000) + "К"
            break
        default:
            cell.participantsCount.text = String(groups[indexPath.row].members_count)
        }
        
        return cell
    }
    
    // Реализация поиска
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        
        guard searchController.searchBar.text != "" else {
            groups.removeAll()
            tableView.reloadData()
            return
        }
        
        VKRequest(sender: self, method: .groupsSearch, parameters: ["fields" : "members_count", "sort" : "0", "q" : searchText.lowercased()], completion: { [weak self] (response: VKModels<VKGroup>) in
            self?.groups = response.items
            self?.tableView.reloadData()
        })
    }
    
}
