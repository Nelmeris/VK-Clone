//
//  GroupsUITableViewCell.swift
//  VK X
//
//  Created by Artem Kufaev on 03.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit

class GroupsUITableViewCell: UITableViewCell {
  @IBOutlet weak var name: UILabel!
  
  @IBOutlet weak var photo: UIImageView! {
    didSet {
      photo.layer.cornerRadius = photo.frame.height / 2
    }
  }
  
  @IBOutlet weak var participantsCount: UILabel!
}

extension GroupsUITableViewCell {
  func setGroupPhoto(_ group: VKGroupModel) {
    guard group.photo100 != "" else { return }
    
    photo.sd_setImage(with: URL(string: group.photo100), completed: nil)
  }
  
  func setGroupPhoto(_ group: VKGroupModel, _ tableView: UITableView, _ indexPath: IndexPath) {
    guard group.photo100 != "" else { return }
    
    let getCacheImageOperation = GetCacheImage(url: group.photo100)
    let setImageToRowOperation = SetImageToGroupsRow(self, indexPath, tableView)
    
    setImageToRowOperation.addDependency(getCacheImageOperation)
    
    let queue: OperationQueue = {
      let queue = OperationQueue()
      queue.qualityOfService = .userInteractive
      return queue
    }()
    queue.addOperation(getCacheImageOperation)
    
    OperationQueue.main.addOperation(setImageToRowOperation)
  }
}
