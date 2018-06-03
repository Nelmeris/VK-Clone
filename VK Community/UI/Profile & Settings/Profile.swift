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
        VKService.request(method: "users.get", parameters: ["fields" : "photo_100"]) { [weak self] (response: VKItemModel<VKUserModel>) in
            VKService.user = response.item
            
            DispatchQueue.main.async {
                self?.userName.text = response.item!.first_name + " " + response.item!.last_name
                
                self?.userImage.sd_setImage(with: URL(string: VKService.user.photo_100), completed: nil)
            }
        }
    }
    
}
