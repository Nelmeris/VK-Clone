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
    let cities = ["Москва", "Санкт-Петербург", "Казань", "Пермь", "Саратов"]
    
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

class Temperaturies: UICollectionViewController {
    var temperaturies: [[Double]] = [[15, 16, 17, 24],
                          [-1, -1, -5, 6],
                          [9, 7, 14, 5],
                          [12, 12, 12, 20],
                          [0, 0, 2, 6]]
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        let label: UILabel = cell.viewWithTag(1) as! UILabel
        label.text = String(temperaturies[city!.row][indexPath.row]) + " C"
        
        return cell
    }
}
