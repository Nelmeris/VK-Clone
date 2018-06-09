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
        
        loadDialogs()
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
        if let indexPath = self.tableView.indexPathForSelectedRow {
            viewController.dialog = (RealmService.loadData()! as Results<VKDialogModel>)[indexPath.row]
        }
    }
    
}



extension DialogsUITableViewController {
    
    func loadDialogs() {
        VKService.request(method: "messages.getDialogs", parameters: ["count" : "50"]) { (response: VKItemsModel<VKDialogModel>) in
            
            var dialogs = response.items
            
            var profilesIdsInt: [Int] = []
            var groupsIdsInt: [Int] = []
            
            for item in dialogs {
                switch item.type {
                case "profile":
                    profilesIdsInt.append(item.id)
                    
                case "group":
                    groupsIdsInt.append(item.id)
                    
                default: break
                }
            }
            
            var profilesIds: String = ""
            for item in profilesIdsInt {
                profilesIds.append(String(item) + ",")
            }
            profilesIds.removeLast()
            
            var groupsIds: String = ""
            for item in groupsIdsInt {
                groupsIds.append(String(item) + ",")
            }
            groupsIds.removeLast()
            
            VKService.request(method: "users.get", parameters: ["user_ids" : profilesIds, "fields" : "photo_100,online"]) { (response: VKUsersResponseModel) in
                var newIndex = 0
                for index in 0...dialogs.count - 1 {
                    if dialogs[index].type == "profile" {
                        dialogs[index].photo100 = response.response[newIndex].photo100
                        dialogs[index].title = response.response[newIndex].firstName + " " + response.response[newIndex].lastName
                        dialogs[index].isOnline = response.response[newIndex].isOnline
                        dialogs[index].isOnlineMobile = response.response[newIndex].isOnlineMobile
                        newIndex += 1
                    }
                }
                
                VKService.request(method: "groups.getById", parameters: ["group_ids" : groupsIds, "fields" : "photo_100"]) { (response: VKGroupsResponseModel) in
                    var newIndex = 0
                    for index in 0...dialogs.count - 1 {
                        if dialogs[index].type == "group" {
                            dialogs[index].photo100 = response.response[newIndex].photo100
                            dialogs[index].title = response.response[newIndex].name
                            newIndex += 1
                        }
                    }
                    
                    dialogs = dialogs.sorted { (d1, d2) -> Bool in
                        return d1.message.date >= d2.message.date
                    }
                    
                    RealmService.updateData(dialogs)
                }
            }
            
        }
    }
    
    
    
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
        
        cell.senderPhoto.constraints.filter { c -> Bool in
            return c.identifier == "Width"
            }[0].constant = 28
        
        if dialog.type == "chat" {
            
            if dialog.message.userId == VKService.user.id {
                cell.senderPhoto.sd_setImage(with: URL(string: VKService.user.photo100), completed: nil)
            } else {
                var users: Results<VKUserModel> = RealmService.loadData()!
                users = users.filter("id = \(dialog.message.userId)")
                if users.count != 0 {
                    cell.senderPhoto.sd_setImage(with: URL(string: users[0].photo100), completed: nil)
                } else {
                    cell.senderPhoto.image = #imageLiteral(resourceName: "DefaultUserPhoto")
                }
            }
            
        } else {
            cell.senderPhoto.sd_setImage(with: URL(string: VKService.user.photo100), completed: nil)
        }
    
    }
    
    func setStatusIcon(_ cell: DialogsUITableViewCell, _ dialog: VKDialogModel) {
        guard dialog.isOnline else { return }
        
        cell.onlineStatusIcon.image = dialog.isOnlineMobile ? #imageLiteral(resourceName: "OnlineMobileIcon") : #imageLiteral(resourceName: "OnlineIcon")
        cell.onlineStatusIcon.backgroundColor = tableView.backgroundColor
        
        cell.onlineStatusIcon.layer.cornerRadius = cell.onlineStatusIcon.frame.height / (dialog.isOnlineMobile ? 7 : 2)
        
        cell.onlineStatusIcon.constraints.filter { c -> Bool in
            return c.identifier == "Width"
            }[0].constant = cell.photo.frame.height / (dialog.isOnlineMobile ? 4.5 : 4)
        
        cell.onlineStatusIcon.constraints.filter { c -> Bool in
            return c.identifier == "Height"
            }[0].constant = cell.photo.frame.height / (dialog.isOnlineMobile ? 3.5 : 4)
    }
    
}
