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
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dialogId = dialog.type == "group" ? -dialog.id : dialog.id
        
        VKService.request(method: "messages.getHistory", parameters: ["peer_id" : String(dialogId), "count" : "100"]) { (response: VKResponseModel<VKMessageResponseModel>) in
            DispatchQueue.main.async {
                self.deleteOldMessages(dialog: self.dialog, newMessages: response.response.items)
                
                self.addNewMessages(dialog: self.dialog, newMessages: response.response.items)
                
                do {
                    let realm = try Realm()
                    realm.beginWrite()
                    self.dialog.in_read = response.response.in_read
                    self.dialog.out_read = response.response.out_read
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
        
        let cellId = message.from_id == VKService.user.id ? "MyMessage" : "SenderMessage"
        
        cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! MessagesUITableViewCell
        
        cell.transform = transform
        
        cell.message.text = message.body
        
        setBackgroudColor(cell, message)
        
        cell.messageDate.text = getDateString(message.date)
        
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
        if message.text != "" {
            VKService.request(method: "messages.send", parameters: ["peer_id" : String(dialogId), "message" : message.text!])
            message.text = ""
        }
    }
    
}



extension MessagesUIViewController {
        
    func setOnlineStatus(_ navigationItem: UINavigationItem) {
        guard dialog.online == 1 else { return }
        
        if dialog.online_mobile == 0 {
            navigationItem.title = navigationItem.title! + " (Онлайн)"
        } else {
            navigationItem.title = navigationItem.title! + " (Онлайн с телефона)"
        }
    }
    
    func setSenderPhoto(_ cell: MessagesUITableViewCell, _ message: VKMessageModel, _ indexPath: IndexPath) {
        guard message.from_id != VKService.user.id else { return }
        
        if (indexPath.row == 0 || dialog.messages[indexPath.row - 1].from_id != message.from_id) {
            var photo = ""
            if dialog.type == "chat" {
                
                var users: Results<VKUserModel> = RealmService.loadData()!
                users = users.filter("id = \(message.user_id)")
                
                if users.count != 0 {
                    photo = users[0].photo_100
                }
                
            } else {
                photo = dialog.photo_100
            }
            
            guard photo != "" else { return }
            
            cell.senderPhoto.sd_setImage(with: URL(string: photo), completed: nil)
        } else {
            cell.senderPhoto.image = nil
        }
    }
    
    func setBackgroudColor(_ cell: MessagesUITableViewCell, _ message: VKMessageModel) {
        guard message.read_state == 0 else { return }
        
        cell.backgroundColor = UIColor(red:0.92, green:0.95, blue:1.00, alpha:1.0)
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
