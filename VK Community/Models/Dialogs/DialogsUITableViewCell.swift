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
            onlineStatusIcon.image = nil
        }
    }
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var lastMessage: UILabel!
    @IBOutlet weak var lastMessageDate: UILabel!
    
    @IBOutlet weak var senderPhoto: UIImageView! {
        didSet {
            senderPhoto.constraints.filter { c -> Bool in
                return c.identifier == "Width"
            }[0].constant = 0
            
            senderPhoto.layer.cornerRadius = senderPhoto.frame.height / 2
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        photo.image = #imageLiteral(resourceName: "DefaultDialogPhoto")
        name.text = nil
        lastMessage.text = nil
        lastMessageDate.text = nil
        
        onlineStatusIcon.image = nil
        onlineStatusIcon.backgroundColor = UIColor.clear
        
        senderPhoto.constraints.filter { c -> Bool in
            return c.identifier == "Width"
            }[0].constant = 0
        
        senderPhoto.layer.cornerRadius = senderPhoto.frame.height / 2
    }
    
}
