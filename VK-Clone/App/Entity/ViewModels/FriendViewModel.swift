//
//  VKNewsFeedModelFactory.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 04.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit

struct FriendViewModel: Hashable {
    let name: String
    let photo: String
    let onlineIcon: OnlineType
}

final class FriendViewModelFactory {
    
    func constructViewModels(from users: [VKUserModel]) -> [FriendViewModel] {
        return users.compactMap(self.viewModel)
    }
    
    private func viewModel(from user: VKUserModel) -> FriendViewModel {
        let name = user.firstName + " " + user.lastName
        let photo = user.avatar.photo100.absoluteString
        let onlineType: OnlineType!
        if !user.isOnline {
            onlineType = .offline
        } else if user.isOnlineMobile {
            onlineType = .mobile
        } else {
            onlineType = .online
        }
        return FriendViewModel(name: name, photo: photo, onlineIcon: onlineType)
    }
    
}
