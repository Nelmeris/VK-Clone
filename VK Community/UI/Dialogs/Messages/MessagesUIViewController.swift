//
//  MessagesUIViewController.swift
//  VK Community
//
//  Created by Артем on 01.06.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import RealmSwift

class MessagesUIViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var dialog: VKDialogModel!
    var dialogId: Int!
    
    var notificationToken: NotificationToken!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            
            RealmService.pairTableViewAndData(sender: tableView, token: &notificationToken, data: AnyRealmCollection(dialog.messages), insertAnimation: .top)
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var message: UITextField! {
        didSet {
            message.delegate = self
            message.layer.cornerRadius = message.frame.height / 2
            message.layer.borderColor = #colorLiteral(red: 0.8901960784, green: 0.8980392157, blue: 0.9137254902, alpha: 1)
            message.layer.borderWidth = 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dialogId = dialog.type == "group" ? -dialog.id : dialog.id
        
        VKService.request(method: "messages.getHistory", parameters: ["peer_id" : String(dialogId), "count" : "20"]) { (response: VKResponseModel<VKMessageResponseModel>) in
            DispatchQueue.main.async {
                self.deleteOldMessages(dialog: self.dialog, newMessages: response.response.items)
                
                self.addNewMessages(dialog: self.dialog, newMessages: response.response.items)
                
                do {
                    let realm = try Realm()
                    realm.beginWrite()
                    self.dialog.inRead = response.response.inRead
                    self.dialog.outRead = response.response.outRead
                    try realm.commitWrite()
                } catch let error {
                    print(error)
                }
            }
        }
    }
    
    let transform = CGAffineTransform(rotationAngle: -3.1415926)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapScreen.cancelsTouchesInView = false
        view.addGestureRecognizer(tapScreen)
        
        navigationItem.title = dialog.title
        
        setOnlineStatus(navigationItem)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        tableView.transform = transform
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dialog.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = dialog.messages[indexPath.row]
        let cell: MessagesUITableViewCell
        
        let cellId = message.fromId == VKService.user.id ? "MyMessage" : "SenderMessage"
        
        cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! MessagesUITableViewCell
        
        cell.transform = transform
        
        cell.messageDate.text = getDateString(message.date)
        
        cell.message.text = message.text
        
        setBackgroudColor(cell, message)
        
        setSenderPhoto(cell, message, indexPath)
        
        return cell
    }
    
    @objc func dismissKeyboard(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShown(notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        
        scrollView?.setContentOffset(CGPoint(x: 0, y: kbSize.height - 80), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if message.returnKeyType == .go {
            sendMessage(self)
        }
        return true
    }
    
    @objc func keyboardWillBeHidden(notification: Notification) {
        scrollView?.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        guard message.text != "" else { return }
        
        VKService.request(method: "messages.send", parameters: ["peer_id" : String(dialogId), "message" : message.text!])
        message.text = ""
    }
    
}



extension MessagesUIViewController {
        
    func setOnlineStatus(_ navigationItem: UINavigationItem) {
        guard dialog.isOnline else { return }
        
        if !dialog.isOnlineMobile {
            navigationItem.title = navigationItem.title! + " (Онлайн)"
        } else {
            navigationItem.title = navigationItem.title! + " (Онлайн с телефона)"
        }
    }
    
    func setSenderPhoto(_ cell: MessagesUITableViewCell, _ message: VKMessageModel, _ indexPath: IndexPath) {
        guard message.fromId != VKService.user.id else { return }
        
        if (indexPath.row == 0 || dialog.messages[indexPath.row - 1].fromId != message.fromId) {
            var photo = ""
            if dialog.type == "chat" {
                
                var users: Results<VKUserModel> = RealmService.loadData()!
                users = users.filter("id = \(message.userId)")
                
                if users.count != 0 {
                    photo = users[0].photo100
                }
                
            } else {
                photo = dialog.photo100
            }
            
            guard photo != "" else { return }
            
            cell.senderPhoto.sd_setImage(with: URL(string: photo), completed: nil)
        } else {
            cell.senderPhoto.image = nil
        }
    }
    
    func setBackgroudColor(_ cell: MessagesUITableViewCell, _ message: VKMessageModel) {
        guard !message.isRead else { return }
        
        cell.backgroundColor = UIColor(red:0.93, green:0.94, blue:0.96, alpha:1.0)
    }
    
    func addNewMessages(dialog: VKDialogModel, newMessages: [VKMessageModel]) {
        for newMessage in newMessages {
            var flag = false
            for message in dialog.messages {
                if newMessage.isEqual(message) {
                    flag = true
                    break
                }
            }
            if !flag {
                addNewMessage(dialog, newMessage)
            }
        }
    }
    
    func addNewMessage(_ dialog: VKDialogModel, _ newMessage: VKMessageModel) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            dialog.messages.append(newMessage)
            try realm.commitWrite()
        } catch let error {
            print(error)
        }
    }
    
    func deleteOldMessages(dialog: VKDialogModel, newMessages: [VKMessageModel]) {
        for message in dialog.messages {
            var flag = false
            for newMessage in newMessages {
                if message.isEqual(newMessage) {
                    flag = true
                    break
                }
            }
            if !flag {
                RealmService.deleteData([message])
            }
        }
    }
    
}
