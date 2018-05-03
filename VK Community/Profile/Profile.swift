//
//  Profile.swift
//  VK Additional Application
//
//  Created by Артем on 29.04.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit

class SettingsList: UITableViewController {
    var exit: Bool = false
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsCells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = settingsCells[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Table", sender: self)
    }
    
    @IBAction func ExitButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        var action = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(action)
        
        action = UIAlertAction(title: "Выйти", style: .destructive, handler: SignOut)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func SignOut(action: UIAlertAction) {
        auth = false
        performSegue(withIdentifier: "Authorization", sender: self)
    }
}
