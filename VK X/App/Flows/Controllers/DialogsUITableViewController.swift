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

  override func viewDidLoad() {
    super.viewDidLoad()

    let data: Results<VKDialogModel>! = RealmService.shared.loadData(keyForSort: "message.date")
    RealmService.shared.pairTableViewAndData(sender: tableView, token: &notificationToken, data: AnyRealmCollection(data))
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    VKService.Methods.Dialogs.get { data in
      RealmService.shared.updateData(data)
    }
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let dialogs: Results<VKDialogModel> = RealmService.shared.loadData(keyForSort: "message.date")!

    return dialogs.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let dialog = (RealmService.shared.loadData(keyForSort: "message.date")! as Results<VKDialogModel>)[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "DialogCell") as! DialogsUITableViewCell

    cell.lastMessageDate.text = getDateString(dialog.message.date)
    cell.lastMessage.text = dialog.message.text
    cell.name.text = dialog.title

    cell.setPhoto(dialog.photo)
    cell.setSenderPhoto(dialog)
    cell.onlineStatusIcon.initial(dialog.isOnline, dialog.isOnlineMobile, cell.photo.frame, tableView.backgroundColor!)

    cell.setNotReadIcon(dialog.message.isRead)

    return cell
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let viewController = segue.destination as! MessagesUIViewController
    guard let indexPath = tableView.indexPathForSelectedRow else { return }

    let dialog = (RealmService.shared.loadData(keyForSort: "message.date")! as Results<VKDialogModel>)[indexPath.row]
    viewController.dialog = dialog
    viewController.dialogId = dialog.id * (dialog.type == "group" ? -1 : 1)
  }
}
