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
            
            PairTableAndData(sender: tableView, token: &notificationToken, data: AnyRealmCollection(dialog.messages), insertAnimation: .top)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dialogId = dialog.type == "group" ? -dialog.id : dialog.id
        
        VKService.request(method: "messages.getHistory", parameters: ["peer_id" : String(dialogId)]) { (response: VKResponseModel<VKMessageResponseModel>) in
            DispatchQueue.main.async {
                deleteOldMessages(dialog: self.dialog, newMessages: response.response.items)
                
                addNewMessages(dialog: self.dialog, newMessages: response.response.items)
                
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dialog.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = dialog.messages[indexPath.row]
        let cell: MessagesUITableViewCell
        
        let cellId = message.from_id == VKService.user.id ? "MyMessage" : "SenderMessage"
        
        cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! MessagesUITableViewCell
        
        let transform = CGAffineTransform(rotationAngle: 3.1415926)
        cell.transform = transform
        
        cell.message.text = message.body
        
        if message.read_state == 0 {
            cell.backgroundColor = UIColor(red:0.92, green:0.95, blue:1.00, alpha:1.0)
        }
        
        let date = Date(timeIntervalSince1970: Double(message.date))
        let dateFormatter = getDateFormatter(date)
        
        cell.messageDate.text = dateFormatter.string(from: date)
        
        if cellId == "SenderMessage" {
            if (indexPath.row == 0 || dialog.messages[indexPath.row - 1].from_id != message.from_id) {
                let photo = dialog.type == "chat" ? message.photo_100 : dialog.photo_100
                cell.senderPhoto.sd_setImage(with: URL(string: photo), completed: nil)
            } else {
                cell.senderPhoto.image = nil
            }
        }
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapScreen.cancelsTouchesInView = false
        view.addGestureRecognizer(tapScreen)
        
        self.title = dialog.title
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let transform = CGAffineTransform(rotationAngle: -3.1415926)
        tableView.transform = transform
    }
    
    @objc func dismissKeyboard(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    
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
    
    //Действие при закрытии клавиатуры
    @objc func keyboardWillBeHidden(notification: Notification) {
        scrollView?.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @IBOutlet weak var message: UITextField! {
        didSet {
            message.delegate = self
        }
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        if message.text != "" {
            VKService.request(method: "messages.send", parameters: ["peer_id" : String(dialogId), "message" : message.text!])
            message.text = ""
        }
    }
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
            RealmDeleteData([message])
        }
    }
}
