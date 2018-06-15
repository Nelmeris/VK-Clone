//
//  DialogsUITableViewCell.swift
//  VK X
//
//  Created by Artem Kufaev on 31.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit
import RealmSwift

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
  
  @IBOutlet weak var leadingSpace: NSLayoutConstraint!
  
  @IBOutlet weak var senderPhoto: UIImageView! {
    didSet {
      senderPhoto.layer.cornerRadius = senderPhoto.frame.height / 2
    }
  }
  
  @IBOutlet weak var senderPhotoWidth: NSLayoutConstraint! {
    didSet {
      senderPhotoWidth.constant = 0
    }
  }
  
  @IBOutlet weak var onlineStatusIconHeight: NSLayoutConstraint!
  @IBOutlet weak var onlineStatusIconWidth: NSLayoutConstraint!
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    photo.image = #imageLiteral(resourceName: "DefaultDialogPhoto")
    name.text = nil
    lastMessage.text = nil
    lastMessageDate.text = nil
    
    onlineStatusIcon.image = nil
    onlineStatusIcon.backgroundColor = .clear
    
    senderPhotoWidth.constant = 0
    
    senderPhoto.layer.cornerRadius = senderPhoto.frame.height / 2
  }
}

extension DialogsUITableViewCell {
  func setDialogPhoto(_ dialog: VKDialogModel) {
    guard dialog.photo100 != "" else { return }
    
    photo.sd_setImage(with: URL(string: dialog.photo100), completed: nil)
  }
  
  func setSenderPhoto(_ dialog: VKDialogModel) {
    guard dialog.type == "chat" || dialog.message.isOut else {
      leadingSpace.constant = 0
      senderPhoto.image = nil
      return
    }
    
    leadingSpace.constant = 7
    senderPhotoWidth.constant = 28
    
    guard !dialog.message.isOut else {
      senderPhoto.sd_setImage(with: URL(string: VKService.shared.user.photo100), completed: nil)
      return
    }
    
    var users: Results<VKUserModel> = RealmService.loadData()!
    users = users.filter("id = \(dialog.message.userId)")
    if !users.isEmpty {
      senderPhoto.sd_setImage(with: URL(string: users.first!.photo100), completed: nil)
    } else {
      senderPhoto.image = #imageLiteral(resourceName: "DefaultUserPhoto")
    }
  }
  
  func setStatusIcon(_ dialog: VKDialogModel, _ backgroundColor: UIColor) {
    guard dialog.isOnline else { return }
    
    onlineStatusIcon.image = (dialog.isOnlineMobile ? #imageLiteral(resourceName: "OnlineMobileIcon") : #imageLiteral(resourceName: "OnlineIcon"))
    onlineStatusIcon.backgroundColor = backgroundColor
    
    onlineStatusIcon.layer.cornerRadius = onlineStatusIcon.frame.height / (dialog.isOnlineMobile ? 7 : 2)
    
    onlineStatusIconWidth.constant = photo.frame.height / (dialog.isOnlineMobile ? 4.5 : 4)
    onlineStatusIconHeight.constant = photo.frame.height / (dialog.isOnlineMobile ? 3.5 : 4)
  }
}
