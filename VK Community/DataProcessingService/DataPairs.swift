//
//  DataPairs.swift
//  VK Community
//
//  Created by Артем on 24.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import RealmSwift
import UIKit

public func PairTableAndData<Type: DataBaseModel>(sender: UITableView, token: inout NotificationToken?, data: AnyRealmCollection<Type>) {
    token = data.observe { (changes: RealmCollectionChange) in
        switch changes {
        case .initial:
            sender.reloadData()
            break
            
        case .update(_, let deletions, let insertions, let modifications):
            sender.beginUpdates()
            sender.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
            sender.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
            sender.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .none)
            sender.endUpdates()
            break
            
        case .error(let error):
            fatalError(error.localizedDescription)
            break
        }
    }
}

public func PairCollectionAndData<Type: DataBaseModel>(sender: UICollectionView, token: inout NotificationToken?, data: AnyRealmCollection<Type>) {
    token = data.observe { (changes: RealmCollectionChange) in
        switch changes {
        case .initial:
            sender.reloadData()
            break
            
        case .update(_, let deletions, let insertions, let modifications):
            sender.insertItems(at: insertions.map({ IndexPath(row: $0, section: 0) }))
            sender.deleteItems(at: deletions.map({ IndexPath(row: $0, section: 0) }))
            sender.reloadItems(at: modifications.map({ IndexPath(row: $0, section: 0) }))
            break
            
        case .error(let error):
            fatalError(error.localizedDescription)
            break
        }
    }
}
