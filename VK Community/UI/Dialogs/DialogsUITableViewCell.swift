//
//  DialogsUITableViewCell.swift
//  VK Community
//
//  Created by Артем on 31.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit

class DialogsUITableViewCell: UITableViewCell {
    
    @IBOutlet weak var photo: UIImageView! {
        didSet {
            photo.layer.cornerRadius = photo.frame.height / 2
        }
    }
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var lastMessage: UILabel!
    @IBOutlet weak var lastMessageDate: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        photo.image = nil
        name.text = ""
        lastMessage.text = ""
        lastMessageDate.text = ""
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        photo.layer.cornerRadius = photo.frame.height / 2
    }
    
}
