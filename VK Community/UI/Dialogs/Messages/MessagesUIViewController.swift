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
    
    var dialog: VKDialogModel! = nil
    var dialogId: Int! = nil
    
    var messages: [VKMessageModel] = []
    var in_read = 0
    var out_read = 0
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch dialog.type {
        case "profile":
            dialogId = dialog.id
        case "chat":
            dialogId = 2000000000 + dialog.id
        case "group":
            dialogId = -dialog.id
        default: break
        }
        
        VKRequest(method: "messages.getHistory", parameters: ["peer_id" : String(dialogId)]) { (response: VKResponseModel<VKMessageResponseModel>) in
            self.messages = response.response.items
            self.in_read = response.response.in_read
            self.out_read = response.response.out_read
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell: MessagesUITableViewCell
        
        if message.from_id == VKUser.id {
            cell = tableView.dequeueReusableCell(withIdentifier: "MyMessage") as! MessagesUITableViewCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "SenderMessage") as! MessagesUITableViewCell
        }
        
        let transform = CGAffineTransform(rotationAngle: 3.1415926)
        cell.transform = transform
        
        cell.message.text = messages[indexPath.row].body
        
        if message.from_id == VKUser.id && out_read < message.id {
            cell.backgroundColor = UIColor(red:0.92, green:0.95, blue:1.00, alpha:1.0)
        }
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapScreen.cancelsTouchesInView = false
        view.addGestureRecognizer(tapScreen)
        
        self.title = dialog.title
        
        VKRequest(method: "messages.getLongPollServer") { (response: VKDataBaseResponseModel<VKMessageLongPollServer>) in
            let data = [response.response!]
            RealmResaveData(data)
            self.setLongPoll(ts: data[0].ts)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let transform = CGAffineTransform(rotationAngle: -3.1415926)
        tableView.transform = transform
    }
    
    func setLongPoll(ts: Int) {
        let longPollData = (RealmLoadData()! as Results<VKMessageLongPollServer>)[0]
        VKRequest(url: "https://\(longPollData.server)?act=a_check&key=\(longPollData.key)&ts=\(ts)&wait=30&mode=104&version=3") { (response: VKResponseModel<VKUpdateModel>) in
            self.setLongPoll(ts: response.response.ts)
            
            for update in response.response.updates {
                self.updateProcessing(update)
            }
        }
    }
    
    @objc func dismissKeyboard(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @objc func keyboardWillShown(notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        
        scrollView?.setContentOffset(CGPoint(x: 0, y: kbSize.height - 75), animated: true)
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
            VKRequest(method: "messages.send", parameters: ["peer_id" : String(dialogId), "message" : message.text!])
            message.text = ""
        }
    }
}



extension MessagesUIViewController {
    
    func updateProcessing(_ update: VKUpdateModel.Update) {
        switch update.code {
        case 4:
            
            let newMessage = update.update as! VKUpdateModel.Update.NewMessage
            if newMessage.peer_id == self.dialog.id {
                self.messages.insert(VKMessageModel(id: newMessage.message_id, text: newMessage.text, from_id: newMessage.flags == 35 ? VKUser.id : newMessage.peer_id), at: 0)
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
                self.tableView.endUpdates()
            }
            
        case 7:
            
            let readMessages = update.update as! VKUpdateModel.Update.ReadMessages
            if readMessages.peer_id == self.dialog.id {
                let messages = self.messages.filter { (message) -> Bool in
                    return message.id >= self.in_read
                }
                self.out_read = readMessages.local_id
                self.tableView.reloadRows(at: messages.map({ IndexPath(row: messages.index(of: $0)!, section: 0) }), with: .none)
            }
            
        default: break
        }
    }
    
}
