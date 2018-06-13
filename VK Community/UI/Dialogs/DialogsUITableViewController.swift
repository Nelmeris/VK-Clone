//
//  DialogsUITableViewController.swift
//  VK Community
//
//  Created by Артем on 31.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import RealmSwift

class DialogsUITableViewController: UITableViewController {
    
    var notificationToken: NotificationToken!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        VKService.methods.getDialogs { data in
            RealmService.updateData(data)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 75
        
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
        
        setDialogPhoto(cell,  dialog)
        setSenderPhoto(cell,  dialog)
        setStatusIcon(cell,  dialog)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! MessagesUIViewController
        guard let indexPath = self.tableView.indexPathForSelectedRow else { return }
        
        viewController.dialog = (RealmService.loadData()! as Results<VKDialogModel>)[indexPath.row]
    }
    
}



extension DialogsUITableViewController {
    
    func setDialogPhoto(_ cell: DialogsUITableViewCell, _ dialog: VKDialogModel) {
        guard dialog.photo100 != "" else { return }
        
        cell.photo.sd_setImage(with: URL(string: dialog.photo100), completed: nil)
    }
    
    func setSenderPhoto(_ cell: DialogsUITableViewCell, _ dialog: VKDialogModel) {
        
        guard dialog.type == "chat" || dialog.message.isOut else {
            cell.leadingSpace.constant = 0
            cell.senderPhoto.image = nil
            return
        }
        
        cell.leadingSpace.constant = 7
        
        cell.senderPhotoWidth.constant = 28
        
        guard dialog.type == "chat" || dialog.message.userId == VKService.user.id else {
            cell.senderPhoto.sd_setImage(with: URL(string: VKService.user.photo100), completed: nil)
            return
        }
            
        var users: Results<VKUserModel> = RealmService.loadData()!
        users = users.filter("id = \(dialog.message.userId)")
        if users.count != 0 {
            cell.senderPhoto.sd_setImage(with: URL(string: users[0].photo100), completed: nil)
        } else {
            cell.senderPhoto.image = #imageLiteral(resourceName: "DefaultUserPhoto")
        }
    
    }
    
    func setStatusIcon(_ cell: DialogsUITableViewCell, _ dialog: VKDialogModel) {
        guard dialog.isOnline else { return }
        
        cell.onlineStatusIcon.image = dialog.isOnlineMobile ? #imageLiteral(resourceName: "OnlineMobileIcon") : #imageLiteral(resourceName: "OnlineIcon")
        cell.onlineStatusIcon.backgroundColor = tableView.backgroundColor
        
        cell.onlineStatusIcon.layer.cornerRadius = cell.onlineStatusIcon.frame.height / (dialog.isOnlineMobile ? 7 : 2)
        
        cell.onlineStatusIconWidth.constant = cell.photo.frame.height / (dialog.isOnlineMobile ? 4.5 : 4)
        
        cell.onlineStatusIconHeight.constant = cell.photo.frame.height / (dialog.isOnlineMobile ? 3.5 : 4)
    }
    
}
