//
//  FriendsTableViewCell.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 03.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit

class FriendsTableViewCell: DataBasicTableViewCell {
    @IBOutlet weak var onlineStatusIcon: OnlineStatusUIImageView!
    
    override func prepareForReuse() {
        onlineStatusIcon.image = nil
        onlineStatusIcon.backgroundColor = nil
    }
    
    func configure(with viewModel: FriendViewModel) {
        name.text = viewModel.name
        setPhoto(viewModel.photo)
        onlineStatusIcon.initial(viewModel.onlineIcon)
    }
}
