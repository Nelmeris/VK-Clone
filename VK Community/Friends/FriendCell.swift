//
//  FriendCell.swift
//  VK Community
//
//  Created by Артем on 03.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var photo: UIImageView!
    
    override func awakeFromNib() {
        photo.layer.cornerRadius = photo.frame.size.height / 2
        photo.contentMode = .scaleAspectFill
        photo.layer.masksToBounds = true
    }
}
