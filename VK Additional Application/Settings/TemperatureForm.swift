//
//  TemperatureForm.swift
//  VK Additional Application
//
//  Created by Артем on 03.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit

enum TemperatureForms {
    case celsius
    case fahrenheit
}

var temperatureForm = TemperatureForms.celsius

class TemperatureForm: UITableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return temperatureForms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        
        if indexPath.row == (temperatureForm == .celsius ? 0 : 1) {
            cell.accessoryType = .checkmark
        }
        
        cell.textLabel?.text = temperatureForms[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != (temperatureForm == .celsius ? 0 : 1) {
            temperatureForm = indexPath.row == 0 ? .celsius : .fahrenheit
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            for index in 0...temperatureForms.count {
                var indexP: IndexPath = indexPath
                indexP.row = index
                if indexP.row == indexPath.row {
                    tableView.cellForRow(at: indexP)?.accessoryType = .checkmark
                } else {
                    tableView.cellForRow(at: indexP)?.accessoryType = .none
                }
            }
        }
    }
}
