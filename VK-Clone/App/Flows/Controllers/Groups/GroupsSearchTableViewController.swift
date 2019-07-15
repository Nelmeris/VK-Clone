//
//  GroupsSearchTableViewController.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 03.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit

class GroupsSearchTableViewController: UITableViewController, UISearchResultsUpdating {
    var groups: [VKGroupModel] = []
    
    var searchController = UISearchController(searchResultsController: nil)
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск..."
        
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchController()
        
        tableView.rowHeight = 55.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = groups[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Group", for: indexPath) as! GroupsTableViewCell
        
        cell.name.text = group.name
        
        cell.setPhoto(group.avatar.photo100.absoluteString, tableView, indexPath)
        
        cell.participantsCount.text = getShortCount(group.membersCount)
        
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            groups.removeAll()
            tableView.reloadData()
            return
        }
        
        VKService.shared.searchGroups(searchText: searchText) { [weak self] groups in
            guard let strongSelf = self else { return }
            strongSelf.groups = groups
            DispatchQueue.main.async {
                strongSelf.tableView.reloadData()
            }
        }
    }
}
