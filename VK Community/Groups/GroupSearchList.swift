//
//  GroupSearchList.swift
//  VK Community
//
//  Created by Артем on 03.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit

class SearchGroupList: UITableViewController, UISearchBarDelegate {
    
    // Инициализация данных о результате поиска групп
    var currentGroups = [VKService.Structs.Group]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        searchBar.delegate = self
        tableView.rowHeight = 75
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            VKService.Methods.groups.search(sender: self, q: searchText.lowercased(), parameters: ["fields": "members_count", "sort": "0"], completion: { response in
                self.currentGroups = response.items
                self.tableView.reloadData()
            })
        } else {
            currentGroups = [VKService.Structs.Group]()
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Group", for: indexPath) as! GroupCell
        
        cell.name.text = currentGroups[indexPath.row].name
        
        let url = URL(string: currentGroups[indexPath.row].photo_100)
        let data = try! Data(contentsOf: url!)
        cell.photo.image = UIImage(data: data)
        
        switch currentGroups[indexPath.row].members_count {
        case let x where x >= 1000000:
            cell.participantsCount.text = String(format: "%.1f", Double(x) / 1000000) + "М"
            break
        case let x where x >= 1000:
            cell.participantsCount.text = String(format: "%.1f", Double(x) / 1000) + "К"
            break
        default:
            cell.participantsCount.text = String(currentGroups[indexPath.row].members_count)
        }
        
        return cell
    }
}
