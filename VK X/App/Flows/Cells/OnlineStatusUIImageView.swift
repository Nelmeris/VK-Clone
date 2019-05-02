//
//  OnlineStatusUIImageView.swift
//  VK X
//
//  Created by Артем Куфаев on 15/06/2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit

class OnlineStatusUIImageView: UIImageView {
  override func awakeFromNib() {
    image = nil
  }

  @IBOutlet weak var onlineStatusIconHeight: NSLayoutConstraint!
  @IBOutlet weak var onlineStatusIconWidth: NSLayoutConstraint!

  func initial(_ isOnline: Bool, _ isOnlineMobile: Bool, _ frame: CGRect, _ backgroundColor: UIColor) {
    guard isOnline else {
      return
    }

    image = (isOnlineMobile ? #imageLiteral(resourceName: "OnlineMobileIcon") : #imageLiteral(resourceName: "OnlineIcon"))
    self.backgroundColor = backgroundColor

    onlineStatusIconWidth.constant = frame.height / (isOnlineMobile ? 4.5 : 4)
    onlineStatusIconHeight.constant = frame.height / (isOnlineMobile ? 3.5 : 4)

    layer.cornerRadius = frame.height / (isOnlineMobile ? 15 : 8)
  }
}
