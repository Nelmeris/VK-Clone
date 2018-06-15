//
//  ProfileAndSettingsUIViewController.swift
//  VK X
//
//  Created by Artem Kufaev on 29.04.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
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
    
    let user = VKService.shared.user!
    userName.text = user.firstName + " " + user.lastName
    userImage.sd_setImage(with: URL(string: user.photo100), completed: nil)
  }
}
