//
//  ProfileAndSettingsUIViewController.swift
//  VK Community
//
//  Created by Артем on 29.04.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileAndSettingsUIViewController: UIViewController {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView! {
        didSet {
            userImage.layer.cornerRadius = userImage.frame.height / 2
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userName.text = VKService.shared.user.firstName + " " + VKService.shared.user.lastName
        
        userImage.sd_setImage(with: URL(string: VKService.shared.user.photo100), completed: nil)
    }
    
}
