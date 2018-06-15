//
//  FriendsUITableViewCell.swift
//  VK X
//
//  Created by Artem Kufaev on 03.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit

class FriendsUITableViewCell: UITableViewCell {
  @IBOutlet weak var firstName: UILabel!
  @IBOutlet weak var lastName: UILabel!
  
  @IBOutlet weak var photo: UIImageView! {
    didSet {
      photo.layer.cornerRadius = photo.frame.height / 2
    }
  }
  
  @IBOutlet weak var onlineStatusIcon: UIImageView! {
    didSet {
      onlineStatusIcon.image = nil
      onlineStatusIcon.layer.cornerRadius = onlineStatusIcon.frame.height / 2
    }
  }
  
  @IBOutlet weak var onlineStatusIconHeight: NSLayoutConstraint!
  @IBOutlet weak var onlineStatusIconWidth: NSLayoutConstraint!
  
  override func prepareForReuse() {
    photo.image = #imageLiteral(resourceName: "DefaultUserPhoto")
    
    onlineStatusIcon.image = nil
    onlineStatusIcon.backgroundColor = .clear
  }
}

extension FriendsUITableViewCell {
  func setUserPhoto(_ friend: VKUserModel, _ tableView: UITableView, _ indexPath: IndexPath) {
    guard friend.photo100 != "" else { return }
    
    let getCacheImageOperation = GetCacheImage(url: friend.photo100)
    let setImageToRowOperation = SetImageToFriendsRow(self, indexPath, tableView)
    
    setImageToRowOperation.addDependency(getCacheImageOperation)
    
    let queue: OperationQueue = {
      let queue = OperationQueue()
      queue.qualityOfService = .userInteractive
      return queue
    }()
    
    queue.addOperation(getCacheImageOperation)
    
    OperationQueue.main.addOperation(setImageToRowOperation)
  }
  
  func setStatusIcon(_ friend: VKUserModel, _ backgroundColor: UIColor) {
    guard friend.isOnline else { return }
    
    onlineStatusIcon.image = (friend.isOnlineMobile ? #imageLiteral(resourceName: "OnlineMobileIcon") : #imageLiteral(resourceName: "OnlineIcon"))
    onlineStatusIcon.backgroundColor = backgroundColor
    
    onlineStatusIcon.layer.cornerRadius = onlineStatusIcon.frame.height / (friend.isOnlineMobile ? 7 : 2)
    
    onlineStatusIconWidth.constant = photo.frame.height / (friend.isOnlineMobile ? 4.5 : 4)
    onlineStatusIconHeight.constant = photo.frame.height / (friend.isOnlineMobile ? 3.5 : 4)
  }
}



class SetImageToFriendsRow: Operation {
  private let indexPath: IndexPath
  private weak var tableView: UITableView?
  private var cell: FriendsUITableViewCell?
  
  init(_ cell: FriendsUITableViewCell, _ indexPath: IndexPath, _ tableView: UITableView) {
    self.indexPath = indexPath
    self.tableView = tableView
    self.cell = cell
  }
  
  override func main() {
    guard let tableView = tableView,
      let cell = cell,
      let getCacheImage = dependencies.first! as? GetCacheImage,
      let image = getCacheImage.outputImage else { return }
    
    guard let newIndexPath = tableView.indexPath(for: cell), newIndexPath == indexPath || tableView.indexPath(for: cell) == nil else { return }
    
    cell.photo.image = image
  }
}
