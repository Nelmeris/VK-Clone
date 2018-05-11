//
//  GroupList.swift
//  VK Community
//
//  Created by Артем on 03.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit

class GroupList: UITableViewController, UISearchBarDelegate {
    
    // Инициализация данных о группах пользователя
    var myGroups = [VKService.Structs.Group]()
    var currentMyGroups = [VKService.Structs.Group]()

    // Получение данных о группах пользователя
    override func viewWillAppear(_ animated: Bool) {
        VKService.Methods.groups.get(sender: self, parameters: ["extended": "1"], completion: { response in
            self.myGroups = response.items
            self.currentMyGroups = self.myGroups
            self.tableView.reloadData()
        })
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Настройки окна
    override func viewDidLoad() {
        searchBar.delegate = self

        tableView.contentOffset.y = searchBar.frame.height
        tableView.rowHeight = 75
    }

    // Скрытие клавиатуры при нажатии на кнопку "Закрыть" на searchBar
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }

    // Скрытие клавиатуры при нажатии на кнопку "Поиск" на searchBar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }

    // Реализация поиска
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

    // Получение количества ячеек для групп пользователя
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentMyGroups.count
    }

    // Составление ячеек для групп пользователя
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroup", for: indexPath) as! GroupCell

        cell.name.text = currentMyGroups[indexPath.row].name
        
        let url = URL(string: currentMyGroups[indexPath.row].photo_100)
        let data = try! Data(contentsOf: url!)
        cell.photo.image = UIImage(data: data)

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
        
        VKService.Method(sender: self, method: .groupsJoin, version: .v5_74, parameters: ["group_id": String(group.id)])
    }

    // Реализация удаления группы из списка групп пользователя
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Покинуть") { (action, indexPath) in
            let alert = UIAlertController(title: "Вы уверены, что хотите покинуть \"\(self.currentMyGroups[indexPath.row].name)\"?", message: nil, preferredStyle: .actionSheet)
            var action = UIAlertAction(title: "Отмена", style: .cancel)
            alert.addAction(action)
            
            action = UIAlertAction(title: "Покинуть", style: .destructive) { (action) in
                VKService.Method(sender: self, method: .groupsLeave, version: .v5_74, parameters: ["group_id": String(self.currentMyGroups[indexPath.row].id)])
                self.myGroups.remove(at: indexPath.row)
                self.currentMyGroups = self.myGroups
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
        }
        return [deleteAction]
    }

}
