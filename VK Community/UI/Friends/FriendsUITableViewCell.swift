//
//  FriendsUITableViewCell.swift
//  VK Community
//
//  Created by Артем on 03.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit

// Ячейка друга
class FriendsUITableViewCell: UITableViewCell {
    
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var onlineStatusIcon: UIImageView!
    @IBOutlet weak var onlineMobileStatusIcon: UIImageView!
    
}
