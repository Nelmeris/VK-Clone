//
//  FriendList.swift
//  VK Community
//
//  Created by Артем on 01.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit

var selectFriend: IndexPath? = nil

class FriendList: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var currentFriends = [Friend]()
    var friends = [Friend]()
    
    override func viewWillAppear(_ animated: Bool) {
        VKService.Methods.Friends(sender: self, method: .get, parameters: ["fields": "id,photo_50"], completion: { responds in
            self.friends = responds
            self.currentFriends = self.friends
            self.tableView.reloadData()
        })
    }
    
    override func viewDidLoad() {
        searchBar.delegate = self
        
        tableView.contentOffset.y = searchBar.frame.height
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
            currentFriends = friends.filter({ friend -> Bool in
                let fullName: String = friend.first_name + " " + friend.last_name
                return fullName.lowercased().contains(searchText.lowercased())
            })
        } else {
            currentFriends = friends
        }
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentFriends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Friend") as! FriendCell
        
        cell.firstName.text = currentFriends[indexPath.row].first_name
        cell.lastName.text = currentFriends[indexPath.row].last_name
        
        guard currentFriends[indexPath.row].photo_50 != "" else {
            cell.photo.image = UIImage(named: "DefaultUserPhoto")
            return cell
        }
        
        let url = URL(string: currentFriends[indexPath.row].photo_50)
        let data = try! Data(contentsOf: url!)
        cell.photo.image = UIImage(data: data)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectFriend = indexPath
    }
}
