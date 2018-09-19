//
//  NewPostUIViewController.swift
//  VK X
//
//  Created by Artem Kufaev on 26/07/2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import MapKit

class NewPostUIViewController: UIViewController, UITextViewDelegate {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var scrollContentViewTopSpace: NSLayoutConstraint!
  
  @IBOutlet weak var postText: UITextView!
  var place: CLPlacemark?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    let tapScreen = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    tapScreen.cancelsTouchesInView = false
    view.addGestureRecognizer(tapScreen)
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShown), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    
    
    postText.delegate = self
    postText.placeholder = "Что нового?"
    
    postText.contentInsetAdjustmentBehavior = .automatic
    postText.becomeFirstResponder()
    
    addActionsBarOnKeyboard()
  }
  
  func addActionsBarOnKeyboard() {
    let actionsBar = UIToolbar()
    actionsBar.barStyle = .default
    
    var items = [UIBarButtonItem]()
    
    let place = UIBarButtonItem(image: #imageLiteral(resourceName: "LocationIcon"), style: .plain, target: self, action: #selector(addPlacement))
    
    items.append(place)
    
    actionsBar.items = items
    
    actionsBar.sizeToFit()
    postText.inputAccessoryView = actionsBar
  }
  
  @objc func addPlacement() {
    guard place == nil else {
      place = nil
      return
    }
    performSegue(withIdentifier: "Map", sender: self)
  }
  
  @IBAction func close(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func addNewPost(_ sender: Any) {
    VKService.Methods.Wall.post(text: postText.text, place: place?.location?.coordinate)
    
    dismiss(animated: true, completion: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let destination = segue.destination as? MapViewUIViewController else { return }
    destination.sender = self
  }
}



extension NewPostUIViewController {
  @objc func dismissKeyboard(sender: UITapGestureRecognizer) {
    view.endEditing(true)
  }
  
  @objc func keyboardWillShown(notification: Notification) {
    let info = notification.userInfo! as NSDictionary
    let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
    
    scrollContentViewTopSpace.constant = kbSize.height
    scrollView?.setContentOffset(CGPoint(x: 0, y: kbSize.height), animated: true)
  }
  
  @objc func keyboardWillBeHidden(notification: Notification) {
    scrollContentViewTopSpace.constant = 0
    scrollView?.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
  }
}
