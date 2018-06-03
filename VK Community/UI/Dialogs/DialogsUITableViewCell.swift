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
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var lastMessage: UILabel!
    @IBOutlet weak var lastMessageDate: UILabel!
    
    @IBOutlet weak var senderPhoto: UIImageView! {
        didSet {
            for constraint in senderPhoto.constraints {
                if constraint.identifier == "Width" {
                    constraint.constant = 0
                }
            }
            senderPhoto.layer.cornerRadius = senderPhoto.frame.height / 2
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        photo.image = #imageLiteral(resourceName: "DefaultDialogPhoto")
        name.text = ""
        lastMessage.text = ""
        lastMessageDate.text = ""
        
        onlineMobileStatusIcon.image = nil
        onlineStatusIcon.image = nil
        onlineMobileStatusIcon.backgroundColor = UIColor.clear
        onlineStatusIcon.backgroundColor = UIColor.clear
        
        for constraint in senderPhoto.constraints {
            if constraint.identifier == "Width" {
                constraint.constant = 0
            }
        }
        senderPhoto.layer.cornerRadius = senderPhoto.frame.height / 2
    }
    
}
