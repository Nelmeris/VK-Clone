//
//  GroupList.swift
//  VK Community
//
//  Created by Артем on 03.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import VKService
import RealmSwift

class GroupList: UITableViewController, UISearchResultsUpdating {
    
    var isAdd = false

    // Получение данных о группах пользователя
    override func viewWillAppear(_ animated: Bool) {
        if isAdd {
            sleep(2)
            isAdd = false
        }
        Request(sender: self, method: .groupsGet, parameters: ["extended" : "1"], completion: { [weak self] (response: [Group]) in
            UpdatingData(response)
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
        let data = LoadData()! as Results<Group>
        return data.count
    }

    // Составление ячеек для групп пользователя
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = (LoadData()! as Results<Group>)[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroup", for: indexPath) as! GroupCell

        cell.name.text = data.name
        
        let url = URL(string: data.photo_100)
        cell.photo.sd_setImage(with: url, completed: nil)

        return cell
    }

    // Реализация присоединения к выбранной группе
    @IBAction func JoinGroup(_ sender: UIStoryboardSegue) {
        let allGroupsController = sender.source as! SearchGroupList
        let group = (LoadData()! as Results<Group>)[allGroupsController.tableView.indexPathForSelectedRow!.row]
        
        Request(sender: self, method: .groupsJoin, parameters: ["group_id" : String(group.id)])
        
        isAdd = true
    }

    // Реализация удаления группы из списка групп пользователя
//    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let deleteAction = UITableViewRowAction(style: .default, title: "Покинуть") { (action, indexPath) in
//            let alert = UIAlertController(title: "Вы уверены, что хотите покинуть \"\(LoadData(Group())![indexPath.row].name)\"?", message: nil, preferredStyle: .actionSheet)
//            var action = UIAlertAction(title: "Отмена", style: .cancel)
//            alert.addAction(action)
//            
//            action = UIAlertAction(title: "Покинуть", style: .destructive) { (action) in
//                Request(sender: self, method: .groupsLeave, parameters: ["group_id" : String(LoadData(Group())![indexPath.row].id)])
//                tableView.deleteRows(at: [indexPath], with: .automatic)
//            }
//            alert.addAction(action)
//            
//            self.present(alert, animated: true, completion: nil)
//        }
//        return [deleteAction]
//    }
    
    // Реализация поиска
    func updateSearchResults(for searchController: UISearchController) {
//        let searchText = searchController.searchBar.text!
//        
//        guard searchController.searchBar.text != "" else {
//            currentMyGroups = myGroups
//            tableView.reloadData()
//            return
//        }
//        
//        currentMyGroups = myGroups.filter({ myGroup -> Bool in
//            return myGroup.name.lowercased().contains(searchText.lowercased())
//        })
//        
//        tableView.reloadData()
    }

}
