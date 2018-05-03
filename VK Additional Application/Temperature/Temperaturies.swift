//
//  Temperaturies.swift
//  VK Additional Application
//
//  Created by Артем on 03.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit

class Temperaturies: UICollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        let label: UILabel = cell.viewWithTag(1) as! UILabel
        switch temperatureForm {
        case .celsius:
            label.text = String(temperaturies[city!.row][indexPath.row]) + " C"
        case .fahrenheit:
            label.text = String(temperaturies[city!.row][indexPath.row] * 1.8 + 30) + " F"
        }
        
        return cell
    }
}
