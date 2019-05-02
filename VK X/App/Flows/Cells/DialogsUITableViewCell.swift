//
//  DialogsUITableViewCell.swift
//  VK X
//
//  Created by Artem Kufaev on 31.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit
import RealmSwift

class DialogsUITableViewCell: DataBasicUITableViewCell {
  @IBOutlet weak var onlineStatusIcon: OnlineStatusUIImageView!

  @IBOutlet weak var lastMessage: UILabel!
  @IBOutlet weak var lastMessageDate: UILabel!

  @IBOutlet weak var leadingSpace: NSLayoutConstraint!

  @IBOutlet weak var senderPhoto: RoundUIImageView!

  @IBOutlet weak var senderPhotoWidth: NSLayoutConstraint! {
    didSet {
      senderPhotoWidth.constant = 0
    }
  }

  @IBOutlet weak var onlineStatusIconHeight: NSLayoutConstraint!
  @IBOutlet weak var onlineStatusIconWidth: NSLayoutConstraint!

  @IBOutlet weak var notReadMessageIcon: UIImageView! {
    didSet {
      notReadMessageIcon.image = nil
    }
  }
  @IBOutlet weak var notReadMessageIconWidth: NSLayoutConstraint! {
    didSet {
      notReadMessageIconWidth.constant = 0
    }
  }

  func setNotReadIcon(_ isRead: Bool) {
    if !isRead {
      notReadMessageIcon.image = #imageLiteral(resourceName: "NotReadMessageIcon")
      notReadMessageIconWidth.constant = 13
    }
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    photo.image = #imageLiteral(resourceName: "DefaultDialogPhoto")
    name.text = nil
    lastMessage.text = nil
    lastMessageDate.text = nil

    onlineStatusIcon.image = nil
    onlineStatusIcon.backgroundColor = nil

    notReadMessageIcon.image = nil
    notReadMessageIconWidth.constant = 0

    senderPhotoWidth.constant = 0

    senderPhoto.layoutSubviews()
  }
}

extension DialogsUITableViewCell {
  func setSenderPhoto(_ dialog: VKDialogModel) {
    guard dialog.type == "chat" || dialog.message.isOut else {
      leadingSpace.constant = 0
      senderPhoto.image = nil
      return
    }

    leadingSpace.constant = 7
    senderPhotoWidth.constant = 28

    guard !dialog.message.isOut else {
      senderPhoto.sd_setImage(with: URL(string: VKService.shared.user.photo), completed: nil)
      return
    }

    var users: Results<VKUserModel> = RealmService.shared.loadData()!
    users = users.filter("id = \(dialog.id)")
    if !users.isEmpty {
      senderPhoto.sd_setImage(with: URL(string: users.first!.photo), completed: nil)
    } else {
      senderPhoto.image = #imageLiteral(resourceName: "DefaultUserPhoto")
    }
  }
}
