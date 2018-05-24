//
//  GroupList.swift
//  VK Community
//
//  Created by Артем on 03.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import RealmSwift

class GroupList: UITableViewController, UISearchResultsUpdating {
    
    var groups: Results<VKGroup>?
    var filteredGroups: Results<VKGroup>?
    var notificationToken: NotificationToken?

    // Получение данных о группах пользователя
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        VKRequest(sender: self, method: .groupsGet, parameters: ["extended" : "1"], completion: { (response: VKModels<VKGroup>) in
            UpdatingData(response.items)
        })
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    // Настройки окна
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 75
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Искать..."
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        groups = LoadData()
        filteredGroups = groups
        PairTableAndData(sender: tableView, token: &notificationToken, data: AnyRealmCollection(groups!))
    }

    // Получение количества ячеек для групп пользователя
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups?.count ?? 0
    }

    // Составление ячеек для групп пользователя
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroup", for: indexPath) as! GroupCell

        cell.name.text = groups?[indexPath.row].name ?? ""
        
        if groups?[indexPath.row].photo_100 != "" {
            let url = URL(string: groups![indexPath.row].photo_100)
            cell.photo.sd_setImage(with: url, completed: nil)
        } else {
            cell.photo.image = UIImage(named: "DefaultGroupPhoto")
        }

        return cell
    }

    // Реализация присоединения к выбранной группе
    @IBAction func JoinGroup(_ sender: UIStoryboardSegue) {
        let allGroupsController = sender.source as! SearchGroupList
        let groups = allGroupsController.groups
        let group = groups[allGroupsController.tableView.indexPathForSelectedRow!.row]
        
        VKRequest(sender: self, method: .groupsJoin, parameters: ["group_id" : String(group.id)], completion: { _ in
            VKRequest(sender: self, method: .groupsGet, parameters: ["extended" : "1"], completion: { (response: VKModels<VKGroup>) in
                UpdatingData(response.items)
            })
        })
    }

    // Реализация удаления группы из списка групп пользователя
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Покинуть") { (action, indexPath) in
            let alert = UIAlertController(title: "Вы уверены, что хотите покинуть \"\(self.groups![indexPath.row].name)\"?", message: nil, preferredStyle: .actionSheet)
            var action = UIAlertAction(title: "Отмена", style: .cancel)
            alert.addAction(action)

            action = UIAlertAction(title: "Покинуть", style: .destructive) { (action) in
                VKRequest(sender: self, method: .groupsLeave, parameters: ["group_id" : String(self.groups![indexPath.row].id)], completion: { _ in
                    VKRequest(sender: self, method: .groupsGet, parameters: ["extended" : "1"], completion: { (response: VKModels<VKGroup>) in
                        UpdatingData(response.items)
                    })
                })
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
            groups = filteredGroups
            tableView.reloadData()
            return
        }
        
        groups = filteredGroups!.filter("name contains[cd] '\(searchText)'")
        
        tableView.reloadData()
    }

}
