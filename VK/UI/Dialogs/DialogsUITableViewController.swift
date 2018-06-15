//
//  DialogsUITableViewController.swift
//  VK X
//
//  Created by Artem Kufaev on 31.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit
import RealmSwift

class DialogsUITableViewController: UITableViewController {
  var notificationToken: NotificationToken!
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    VKService.shared.getDialogs { data in
      RealmService.updateData(data)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let data: Results<VKDialogModel>! = RealmService.loadData()
    RealmService.pairTableViewAndData(sender: tableView, token: &notificationToken, data: AnyRealmCollection(data))
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let dialogs: Results<VKDialogModel> = RealmService.loadData()!
    
    return dialogs.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let dialog = (RealmService.loadData()! as Results<VKDialogModel>)[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "DialogCell") as! DialogsUITableViewCell
    
    cell.lastMessageDate.text = getDateString(dialog.message.date)
    cell.lastMessage.text = dialog.message.text
    cell.name.text = dialog.title
    
    cell.setDialogPhoto(dialog)
    cell.setSenderPhoto(dialog)
    cell.setStatusIcon(dialog, tableView.backgroundColor!)
    
    return cell
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let viewController = segue.destination as! MessagesUIViewController
    guard let indexPath = tableView.indexPathForSelectedRow else { return }
    
    let dialog = (RealmService.loadData()! as Results<VKDialogModel>)[indexPath.row]
    viewController.dialog = dialog
    viewController.dialogId = dialog.id * (dialog.type == "group" ? -1 : 1)
  }
}
