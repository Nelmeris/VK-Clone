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
    
    var notificationToken: NotificationToken?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        VKRequest(method: "messages.getDialogs") { (response: VKItemsModel<VKDialogModel>) in
            RealmClearData(response.items)
            RealmSaveData(response.items)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 75
        
        let data: Results<VKDialogModel>! = RealmLoadData()
        
        PairTableAndData(sender: tableView, token: &notificationToken, data: AnyRealmCollection(data))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dialogs: Results<VKDialogModel> = RealmLoadData()!
        
        return dialogs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dialog = (RealmLoadData()! as Results<VKDialogModel>)[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DialogCell") as! DialogsUITableViewCell
        
        let date = Date(timeIntervalSince1970: Double(dialog.message.date))
        cell.lastMessageDate.text = date.description
        cell.lastMessage.text = dialog.message.body
        
        return cell
    }
    
}
