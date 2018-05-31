//
//  GroupsSearchUITableViewController.swift
//  VK Community
//
//  Created by Артем on 03.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import RealmSwift

class GroupsSearchUITableViewController: UITableViewController, UISearchResultsUpdating {
    
    var groups = [VKGroupModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        groups.removeAll()
    }
    
    var searchController = UISearchController(searchResultsController: nil) {
        didSet {
            searchController.searchResultsUpdater = self
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.placeholder = "Поиск..."
            
            navigationItem.hidesSearchBarWhenScrolling = false
            navigationItem.searchController = searchController
        }
    }
    
    //Настройка окна
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 75
    }
    
    // Получение количества ячеек для результата поиска
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    // Составление ячеек для результата поиска
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = groups[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Group", for: indexPath) as! GroupsUITableViewCell
        
        cell.name.text = group.name
        
        cell.photo.sd_setImage(with: URL(string: group.photo_100), completed: nil)
        
        cell.participantsCount.text = getShortCount(group.members_count)
        
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
        
        VKRequest(method: "groups.search", parameters: ["fields" : "members_count", "sort" : "0", "q" : searchText.lowercased()]) { [weak self] (response: VKItemsModel<VKGroupModel>) in
            self?.groups = response.items
            self?.tableView.reloadData()
        }
    }
    
}
