//
//  Settings.swift
//  VK Additional Application
//
//  Created by Артем on 29.04.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit

class Settings: UITableViewController {
    var exit: Bool = false
    
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

enum temperatureForms {
    case celsius
    case fahrenheit
}

var temperatureForm = temperatureForms.celsius

class TemperatureForm: UITableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            temperatureForm = .celsius
        } else {
            temperatureForm = .fahrenheit
        }
    }
}
