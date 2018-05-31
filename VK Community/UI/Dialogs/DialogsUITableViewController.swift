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
        
        VKRequest(method: "messages.getDialogs", parameters: ["count" : "50"]) { (response: VKItemsModel<VKDialogModel>) in
            RealmUpdateData(response.items)
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
        let dateFormatter = getDateFormatter(date)
        
        cell.lastMessageDate.text = dateFormatter.string(from: date)
        
        cell.lastMessage.text = dialog.message.body
        
        if dialog.type == "chat" {
            cell.name.text = dialog.title
            cell.photo.sd_setImage(with: URL(string: dialog.photo_200), completed: nil)
        }
        
        return cell
    }
    
    func getDateFormatter(_ date: Date) -> DateFormatter {
        let dateFormatter = DateFormatter()
        
        switch Calendar.current {
        case let x where x.component(.day, from: date) == x.component(.day, from: Date()):
            dateFormatter.dateFormat = "hh:mm"
        case _ where Date().timeIntervalSince(date) <= 172800:
            dateFormatter.dateFormat = "вчера"
        case let x where x.component(.year, from: date) == x.component(.year, from: Date()):
            dateFormatter.dateFormat = "dd MMM"
        default:
            dateFormatter.dateFormat = "dd.MM.yyyy"
        }
        
        return dateFormatter
    }
    
}
