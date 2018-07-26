//
//  RealmDataPairs.swift
//  VK X
//
//  Created by Artem Kufaev on 24.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit
import RealmSwift

extension RealmService {
  static func pairTableViewAndData<Type: RealmModel>(sender: UITableView, token: inout NotificationToken?, data: AnyRealmCollection<Type>, insertAnimation: UITableViewRowAnimation = .automatic) {
    token = data.observe { (changes: RealmCollectionChange) in
      switch changes {
      case .initial:
        sender.reloadData()
        
      case .update(_, let deletions, let insertions, let modifications):
        sender.beginUpdates()
        sender.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: insertAnimation)
        sender.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
        sender.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .none)
        sender.endUpdates()
        
      case .error(let error):
        fatalError(error.localizedDescription)
      }
    }
  }
  
  static func pairCollectionViewAndData<Type: RealmModel>(sender: UICollectionView, token: inout NotificationToken?, data: AnyRealmCollection<Type>) {
    token = data.observe { (changes: RealmCollectionChange) in
      switch changes {
      case .initial:
        sender.reloadData()
        
      case .update(_, let deletions, let insertions, let modifications):
        sender.insertItems(at: insertions.map { IndexPath(row: $0, section: 0) })
        sender.deleteItems(at: deletions.map { IndexPath(row: $0, section: 0) })
        sender.reloadItems(at: modifications.map { IndexPath(row: $0, section: 0) })
        
      case .error(let error):
        fatalError(error.localizedDescription)
      }
    }
  }
}
