//
//  GroupSearchList.swift
//  VK Community
//
//  Created by Артем on 03.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit

class SearchGroupList: UITableViewController, UISearchBarDelegate {
    var currentGroups = groups
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        tableView.contentOffset.y = searchBar.frame.height
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            currentGroups = groups.filter({ group -> Bool in
                return group.name.lowercased().contains(searchText.lowercased())
            })
        } else {
            currentGroups = groups
        }
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Group", for: indexPath) as! GroupCell
        
        cell.name.text = currentGroups[indexPath.row].name
        cell.photo.image = UIImage(named: currentGroups[indexPath.row].photo)
        switch currentGroups[indexPath.row].participantsCount {
        case let x where x >= 1000000:
            cell.participantsCount.text = String(format: "%.1f", Double(currentGroups[indexPath.row].participantsCount) / 1000000) + "М"
            break
        case let x where x >= 1000:
            cell.participantsCount.text = String(format: "%.1f", Double(currentGroups[indexPath.row].participantsCount) / 1000) + "К"
            break
        default:
            cell.participantsCount.text = String(currentGroups[indexPath.row].participantsCount)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
