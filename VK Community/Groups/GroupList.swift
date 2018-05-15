//
//  GroupList.swift
//  VK Community
//
//  Created by Артем on 03.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit

class GroupList: UITableViewController, UISearchResultsUpdating {
    
    // Инициализация данных о группах пользователя
    var myGroups = [Group]()
    var currentMyGroups = [Group]()

    // Получение данных о группах пользователя
    override func viewWillAppear(_ animated: Bool) {
        sleep(2)
        VKService.Requests.groups.get(sender: self, version: .v5_74, parameters: ["extended": "1"], completion: { [weak self] (response) in
            self?.myGroups = response
            self?.currentMyGroups = response
            self?.tableView.reloadData()
        })
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    // Настройки окна
    override func viewDidLoad() {
        tableView.rowHeight = 75
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Искать..."
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    // Получение количества ячеек для групп пользователя
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentMyGroups.count
    }

    // Составление ячеек для групп пользователя
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroup", for: indexPath) as! GroupCell

        cell.name.text = currentMyGroups[indexPath.row].name
        
        let url = URL(string: currentMyGroups[indexPath.row].photo_100)
        cell.photo.sd_setImage(with: url, completed: nil)

        return cell
    }

    // Реализация присоединения к выбранной группе
    @IBAction func JoinGroup(_ sender: UIStoryboardSegue) {
        let allGroupsController = sender.source as! SearchGroupList
        let group = allGroupsController.currentGroups[allGroupsController.tableView.indexPathForSelectedRow!.row]
        
        guard !myGroups.contains(where: { Group -> Bool in
            return group.name == Group.name
        }) else {
            return
        }
        
        VKService.IrretrievableRequest(sender: self, method: .groupsJoin, version: .v5_74, parameters: ["group_id": String(group.id)])
    }

    // Реализация удаления группы из списка групп пользователя
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Покинуть") { (action, indexPath) in
            let alert = UIAlertController(title: "Вы уверены, что хотите покинуть \"\(self.currentMyGroups[indexPath.row].name)\"?", message: nil, preferredStyle: .actionSheet)
            var action = UIAlertAction(title: "Отмена", style: .cancel)
            alert.addAction(action)
            
            action = UIAlertAction(title: "Покинуть", style: .destructive) { (action) in
                VKService.IrretrievableRequest(sender: self, method: .groupsLeave, version: .v5_74, parameters: ["group_id": String(self.currentMyGroups[indexPath.row].id)])
                self.myGroups.remove(at: indexPath.row)
                self.currentMyGroups = self.myGroups
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
        }
        return [deleteAction]
    }
    
    // Реализация поиска
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        
        guard searchController.searchBar.text != "" else {
            currentMyGroups = myGroups
            tableView.reloadData()
            return
        }
        
        currentMyGroups = myGroups.filter({ myGroup -> Bool in
            return myGroup.name.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }

}
