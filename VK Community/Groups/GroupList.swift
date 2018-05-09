//
//  GroupList.swift
//  VK Community
//
//  Created by Артем on 03.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit

class GroupList: UITableViewController, UISearchBarDelegate {
//    var currentMyGroups = myGroups
    
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        searchBar.delegate = self

        tableView.contentOffset.y = searchBar.frame.height
        tableView.rowHeight = 75
    }

//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        view.endEditing(true)
//    }
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        view.endEditing(true)
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if !searchText.isEmpty {
//            currentMyGroups = myGroups.filter({ myGroup -> Bool in
//                return myGroup.name.lowercased().contains(searchText.lowercased())
//            })
//        } else {
//            currentMyGroups = myGroups
//        }
//
//        tableView.reloadData()
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return currentMyGroups.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroup", for: indexPath) as! GroupCell
//
//        cell.name.text = currentMyGroups[indexPath.row].name
//        cell.photo.image = UIImage(named: currentMyGroups[indexPath.row].photo)
//
//        return cell
//    }
//
//    @IBAction func AddGroup(_ sender: UIStoryboardSegue) {
//        let allGroupsController = sender.source as! SearchGroupList
//        let group = groups[allGroupsController.tableView.indexPathForSelectedRow!.row]
//        guard !myGroups.contains(where: { Group -> Bool in
//            return group.name == Group.name
//        }) else {
//            return
//        }
//        currentMyGroups.append(group)
//        myGroups.append(group)
//        tableView.reloadData()
//    }
//
//    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let deleteAction = UITableViewRowAction(style: .default, title: "Удалить") { (action, indexPath) in
//            myGroups.remove(at: indexPath.row)
//            self.currentMyGroups = myGroups
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//        }
//        return [deleteAction]
//    }
}
