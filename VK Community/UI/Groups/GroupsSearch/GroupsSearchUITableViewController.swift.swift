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
    
    var groups: [VKGroupModel] = []
    
    var searchController = UISearchController(searchResultsController: nil)
    
    func initSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск..."
        
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSearchController()
        
        tableView.rowHeight = 75
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = groups[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Group", for: indexPath) as! GroupsUITableViewCell
        
        cell.name.text = group.name
        
        setGroupPhoto(cell, group)
        
        cell.participantsCount.text = getShortCount(group.members_count)
        
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard searchController.searchBar.text != "" else {
            groups.removeAll()
            tableView.reloadData()
            return
        }
        
        let searchText = searchController.searchBar.text!
        
        VKService.request(method: "groups.search", parameters: ["fields" : "members_count", "sort" : "0", "q" : searchText]) { [weak self] (response: VKItemsModel<VKGroupModel>) in
            self?.groups = response.items
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
}



extension GroupsSearchUITableViewController {
    
    func setGroupPhoto(_ cell: GroupsUITableViewCell, _ group: VKGroupModel) {
        guard group.photo_100 != "" else { return }
        
        cell.photo.sd_setImage(with: URL(string: group.photo_100), completed: nil)
    }
    
}
