//
//  GroupViewModel.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 05.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit

struct GroupViewModel {
    let name: String
    let photo: String
}

final class GroupViewModelFactory {
    
    func constructViewModels(from groups: [VKGroupModel]) -> [GroupViewModel] {
        return groups.compactMap(self.viewModel)
    }
    
    private func viewModel(from group: VKGroupModel) -> GroupViewModel {
        let name = group.name
        let photo = group.avatar.photo100.absoluteString
        return GroupViewModel(name: name, photo: photo)
    }
    
}
