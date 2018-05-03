//
//  GroupList.swift
//  VK Additional Application
//
//  Created by Артем on 03.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit

class GroupList: UITableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard myGroups != nil else {
            return 0
        }
        return myGroups!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroup", for: indexPath) as! GroupCell
        
        cell.groupName.text = myGroups![indexPath.row]
        
        return cell
    }
    
    @IBAction func AddGroup(_ sender: UIStoryboardSegue) {
        
    }
}
