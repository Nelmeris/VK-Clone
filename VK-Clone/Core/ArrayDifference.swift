//
//  ArrayDifference.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 06/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    
    enum DataUpdateType {
        case deleted, added
    }
    
    struct DataUpdateInfo {
        let type: DataUpdateType
        let index: Int
    }
    
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
    
    func updateInforms(from other: [Element]) -> [DataUpdateInfo] {
        let array = self
        let different = self.difference(from: other)
        var updateInforms = [DataUpdateInfo]()
        for diffElement in different {
            if (self.contains(diffElement)) {
                for index in 0...array.count {
                    if array[index] == diffElement {
                        updateInforms.append(DataUpdateInfo(type: .deleted, index: index))
                        break
                    }
                }
            } else {
                for index in 0...other.count {
                    if other[index] == diffElement {
                        updateInforms.append(DataUpdateInfo(type: .added, index: index))
                        break
                    }
                }
            }
        }
        return updateInforms
    }
    
}
