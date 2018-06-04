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
        cell.lastMessage.text = dialog.message.body
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
                if item.type == "profile" {
                    profilesIdsInt.append(item.id)
                }
                
                if item.type == "group" {
                    groupsIdsInt.append(item.id)
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
                        dialogs[index].photo_100 = response.response[newIndex].photo_100
                        dialogs[index].title = response.response[newIndex].first_name + " " + response.response[newIndex].last_name
                        dialogs[index].online = response.response[newIndex].online
                        dialogs[index].online_mobile = response.response[newIndex].online_mobile
                        newIndex += 1
                    }
                }
                
                VKService.request(method: "groups.getById", parameters: ["group_ids" : groupsIds, "fields" : "photo_100"]) { (response: VKGroupsResponseModel) in
                    var newIndex = 0
                    for index in 0...dialogs.count - 1 {
                        if dialogs[index].type == "group" {
                            dialogs[index].photo_100 = response.response[newIndex].photo_100
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
        guard dialog.photo_100 != "" else { return }
        
        cell.photo.sd_setImage(with: URL(string: dialog.photo_100), completed: nil)
    }
    
    func setSenderPhoto(_ cell: DialogsUITableViewCell, _ dialog: VKDialogModel) {
        
        if dialog.type == "chat" || dialog.message.out == 1 {
            cell.senderPhoto.constraints.filter { c -> Bool in
                return c.identifier == "Width"
            }[0].constant = 24
        }
        
        if dialog.type == "chat" {
            
            if dialog.message.user_id == VKService.user.id {
                cell.senderPhoto.sd_setImage(with: URL(string: VKService.user.photo_100), completed: nil)
            } else {
                var users: Results<VKUserModel> = RealmService.loadData()!
                users = users.filter("id = \(dialog.message.user_id)")
                if users.count != 0 {
                    cell.senderPhoto.sd_setImage(with: URL(string: users[0].photo_100), completed: nil)
                } else {
                    cell.senderPhoto.image = #imageLiteral(resourceName: "DefaultUserPhoto")
                }
            }
            
        } else {
            cell.senderPhoto.sd_setImage(with: URL(string: VKService.user.photo_100), completed: nil)
        }
    
    }
    
    func setStatusIcon(_ cell: DialogsUITableViewCell, _ dialog: VKDialogModel) {
        if dialog.online == 1 {
            cell.onlineStatusIcon.image = dialog.online_mobile == 1 ? #imageLiteral(resourceName: "OnlineMobileIcon") : #imageLiteral(resourceName: "OnlineIcon")
            cell.onlineStatusIcon.backgroundColor = tableView.backgroundColor
            
            cell.onlineStatusIcon.layer.cornerRadius = dialog.online_mobile == 1 ?
                cell.onlineStatusIcon.frame.height / 10 :
                cell.onlineStatusIcon.frame.height / 2
            
            cell.onlineStatusIcon.constraints.filter { c -> Bool in
                return c.identifier == "Width"
                }[0].constant = dialog.online_mobile == 1 ?
                    cell.photo.frame.height / 4.5 :
                    cell.photo.frame.height / 4
            
            cell.onlineStatusIcon.constraints.filter { c -> Bool in
                return c.identifier == "Height"
                }[0].constant = dialog.online_mobile == 1 ?
                    cell.photo.frame.height / 3.5 :
                    cell.photo.frame.height / 4
        } else {
            cell.onlineStatusIcon.image = nil
            cell.onlineStatusIcon.backgroundColor = UIColor.clear
        }
    }
    
}
