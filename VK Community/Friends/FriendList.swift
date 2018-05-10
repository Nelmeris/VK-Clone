//
//  FriendList.swift
//  VK Community
//
//  Created by Артем on 01.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit

class FriendList: UITableViewController, UISearchBarDelegate {
    
    // Инициализация данных о друзьях
    var currentFriends = [VKService.Structs.Friend]()
    var friends = [VKService.Structs.Friend]()
    
    // Получение данных о друзьях
    override func viewWillAppear(_ animated: Bool) {
        VKService.Methods.friends.get(sender: self, parameters: ["fields": "id,photo_100"], completion: { response in
            self.friends = response.items
            self.currentFriends = self.friends
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
            currentFriends = friends.filter({ friend -> Bool in
                let fullName: String = friend.first_name + " " + friend.last_name
                return fullName.lowercased().contains(searchText.lowercased())
            })
        } else {
            currentFriends = friends
        }
        
        tableView.reloadData()
    }
    
    // Получение количества ячеек для друзей
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentFriends.count
    }
    
    // Составление ячеек для друзей
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Friend") as! FriendCell
        
        cell.firstName.text = currentFriends[indexPath.row].first_name
        cell.lastName.text = currentFriends[indexPath.row].last_name
        
        guard currentFriends[indexPath.row].photo_100 != "" else {
            cell.photo.image = UIImage(named: "DefaultUserPhoto")
            return cell
        }
        
        let url = URL(string: currentFriends[indexPath.row].photo_100)
        let data = try! Data(contentsOf: url!)
        cell.photo.image = UIImage(data: data)
        
        return cell
    }
    
    // Передача ID выбранного друга на следующий экран
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! FriendPhotoCollection
        if let indexPath = self.tableView.indexPathForSelectedRow {
            vc.userID = currentFriends[indexPath.row].id
        }
    }
    
}
