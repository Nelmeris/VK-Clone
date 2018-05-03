//
//  Cities.swift
//  VK Additional Application
//
//  Created by Артем on 01.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit

var city: IndexPath? = nil

class Cities: UITableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = cities[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        city = indexPath
        performSegue(withIdentifier: "Segue", sender: self)
    }
}
