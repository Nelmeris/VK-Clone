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
    var messages: VKMessageResponseModel? = nil
    var dialogId: Int! = nil
    
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
            self.messages = response.response
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages!.items[indexPath.row]
        
        if message.from_id == VKUser.id {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyMessage") as! MessagesMyUITableViewCell
            
            let transform = CGAffineTransform(rotationAngle: 3.1415926)
            cell.transform = transform
            
            cell.message.text = messages!.items[indexPath.row].body
            
            if messages!.out_read < message.id {
                cell.backgroundColor = UIColor(red:0.92, green:0.95, blue:1.00, alpha:1.0)
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SenderMessage") as! MessagesSenderUITableViewCell
            cell.message.text = messages!.items[indexPath.row].body
            
            let transform = CGAffineTransform(rotationAngle: 3.1415926)
            cell.transform = transform
            
            return cell
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapScreen.cancelsTouchesInView = false
        view.addGestureRecognizer(tapScreen)
        
        self.title = dialog.title
        
        VKRequest(method: "messages.getLongPollServer") { (response: VKDataBaseResponseModel<VKMessageLongPollServer>) in
            RealmResaveData([response.response])
            self.setLongPoll(ts: response.response.ts)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let transform = CGAffineTransform(rotationAngle: -3.1415926)
        tableView.transform = transform
    }
    
    func setLongPoll(ts: Int) {
        let longPollData = (RealmLoadData()! as Results<VKMessageLongPollServer>)[0]
        VKRequest(url: "https://\(longPollData.server)?act=a_check&key=\(longPollData.key)&ts=\(ts)&wait=90&mode=104&version=3") { (response: VKResponseModel<VKMessageLongPollResponse>) in
            if response.response.updates.count != 0 {
                for message in response.response.updates {
                    if message.id == self.dialog.id && message.code == 4 {
                        self.messages?.items.insert(VKMessageModel(text: message.text, from_id: message.id), at: 0)
                    }
                }
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                self.tableView.endUpdates()
            }
            self.setLongPoll(ts: response.response.ts)
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
            VKRequest(method: "messages.send", parameters: ["peer_id" : String(dialogId), "message" : message.text!]) { _ in
                self.message.text = ""
            }
        }
    }
}
