//
//  UITableViewUpdater.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 06/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import UIKit

extension UITableView {
    
    func updateData<T: Hashable>(data: [T], newData: [T], with animation: UITableView.RowAnimation = .automatic) {
        let updateInforms = data.updateInforms(from: newData)
        var deleteIndexPaths = [IndexPath]()
        var insertIndexPaths = [IndexPath]()
        for updateInfo in updateInforms {
            let indexPath = IndexPath(row: updateInfo.index, section: 0)
            if updateInfo.type == .deleted {
                deleteIndexPaths.append(indexPath)
            } else {
                insertIndexPaths.append(indexPath)
            }
        }
        self.deleteRows(at: deleteIndexPaths, with: animation)
        self.insertRows(at: insertIndexPaths, with: animation)
    }
    
}
