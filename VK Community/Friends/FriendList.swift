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
    var currentFriend = friends
    
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
            currentFriend = friends.filter({ friend -> Bool in
                let fullName: String = friend.firstName + " " + friend.lastName
                return fullName.lowercased().contains(searchText.lowercased())
            })
        } else {
            currentFriend = friends
        }
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentFriend.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Friend") as! FriendCell
        
        cell.firstName.text = currentFriend[indexPath.row].firstName
        cell.lastName.text = currentFriend[indexPath.row].lastName
        cell.photo.image = UIImage(named: currentFriend[indexPath.row].photo)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectFriend = indexPath
    }
    
    @IBAction func LogIn(_ sender: UIStoryboardSegue) {
        tableView.reloadData()
        auth = true
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
