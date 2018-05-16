//
//  GroupSearchList.swift
//  VK Community
//
//  Created by Артем on 03.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import VKService
import RealmSwift

class SearchGroupList: UITableViewController, UISearchResultsUpdating {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewWillAppear(_ animated: Bool) {
        SaveData([Group]())
        tableView.reloadData()
    }
    
    //Настройка окна
    override func viewDidLoad() {
        SaveData([Group]())
        
        tableView.rowHeight = 75
        
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск..."
        navigationItem.searchController = searchController
    }
    
    // Получение количества ячеек для результата поиска
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LoadData(Group())!.count
    }
    
    // Составление ячеек для результата поиска
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Group", for: indexPath) as! GroupCell
        
        cell.name.text = LoadData(Group())![indexPath.row].name
        
        let url = URL(string: LoadData(Group())![indexPath.row].photo_100)
        cell.photo.sd_setImage(with: url, completed: nil)
        
        switch LoadData(Group())![indexPath.row].members_count {
        case let x where x >= 1000000:
            cell.participantsCount.text = String(format: "%.1f", Double(x) / 1000000) + "М"
            break
        case let x where x >= 1000:
            cell.participantsCount.text = String(format: "%.1f", Double(x) / 1000) + "К"
            break
        default:
            cell.participantsCount.text = String(LoadData(Group())![indexPath.row].members_count)
        }
        
        return cell
    }
    
    // Реализация поиска
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        
        guard searchController.searchBar.text != "" else {
            SaveData([Group]())
            tableView.reloadData()
            return
        }
        
        Request(sender: self, method: .groupsSearch, parameters: ["fields" : "members_count", "sort" : "0", "q" : searchText.lowercased()], completion: { [weak self] (response: [Group]) in
            SaveData(response)
            self?.tableView.reloadData()
        })
    }
    
}
