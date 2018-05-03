//
//  FriendList.swift
//  VK Additional Application
//
//  Created by Артем on 01.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit

var selectFriend: IndexPath? = nil

class FriendList: UITableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Friend")
        
        let label = cell?.viewWithTag(2) as! UILabel
        label.text = friends[indexPath.row]
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectFriend = indexPath
        performSegue(withIdentifier: "FriendPhotoCollection", sender: self)
    }
    
    @IBAction func LogIn(_ sender: UIStoryboardSegue) {
        tableView.reloadData()
        auth = true
    }
}
