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
    
    @IBOutlet weak var photo: UIImageView! {
        didSet {
            photo.layer.cornerRadius = photo.frame.height / 2
        }
    }
    
    @IBOutlet weak var onlineStatusIcon: UIImageView! {
        didSet {
            onlineStatusIcon.layer.cornerRadius = onlineStatusIcon.frame.height / 2
        }
    }
    
    @IBOutlet weak var onlineMobileStatusIcon: UIImageView! {
        didSet {
            onlineMobileStatusIcon.layer.cornerRadius = onlineMobileStatusIcon.frame.height / 10
        }
    }
    
}
