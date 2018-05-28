//
//  Profile.swift
//  VK Community
//
//  Created by Артем on 29.04.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileAndSettings: UIViewController {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        VKRequest(sender: self, method: "users.get", parameters: ["fields" : "photo_100"]) { (response: VKItem<VKUser>) in
            self.userName.text = response.item!.first_name + " " + response.item!.last_name
            
            let url = URL(string: response.item!.photo_100)
            self.userImage.sd_setImage(with: url, completed: nil)
        }
    }
    
}
