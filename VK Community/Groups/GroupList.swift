//
//  GroupList.swift
//  VK Community
//
//  Created by Артем on 03.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit

class GroupList: UITableViewController, UISearchBarDelegate {
    var currentMyGroups = myGroups
    
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
            currentMyGroups = myGroups.filter({ myGroup -> Bool in
                return myGroup.name.lowercased().contains(searchText.lowercased())
            })
        } else {
            currentMyGroups = myGroups
        }
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentMyGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroup", for: indexPath) as! GroupCell
        
        cell.name.text = currentMyGroups[indexPath.row].name
        cell.photo.image = UIImage(named: currentMyGroups[indexPath.row].photo)
        
        return cell
    }
    
    @IBAction func AddGroup(_ sender: UIStoryboardSegue) {
        let allGroupsController = sender.source as! SearchGroupList
        let city = groups[allGroupsController.tableView.indexPathForSelectedRow!.row]
        currentMyGroups.append(city)
        myGroups.append(city)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
