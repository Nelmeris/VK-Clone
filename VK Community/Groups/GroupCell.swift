//
//  GroupCell.swift
//  VK Community
//
//  Created by Артем on 03.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var photo: UIImageView!
    
    override func awakeFromNib() {
        photo.layer.cornerRadius = 30
        photo.contentMode = .scaleAspectFill
        photo.layer.masksToBounds = true
    }
}
