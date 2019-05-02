//
//  FriendsUITableViewCell.swift
//  VK X
//
//  Created by Artem Kufaev on 03.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit

class FriendsUITableViewCell: DataBasicUITableViewCell {
  @IBOutlet weak var onlineStatusIcon: OnlineStatusUIImageView!

  override func prepareForReuse() {
    onlineStatusIcon.image = nil
    onlineStatusIcon.backgroundColor = nil
  }
}
