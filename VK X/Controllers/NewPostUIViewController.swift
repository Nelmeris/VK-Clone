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
  
  @IBOutlet weak var geostationButton: UIBarButtonItem!
  
  var kbHeight: CGFloat = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let tapScreen = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    tapScreen.cancelsTouchesInView = false
    view.addGestureRecognizer(tapScreen)
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShown), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    
    postText.delegate = self
    postText.text = "Что нового?"
    postText.textColor = .lightGray
    
    // Do any additional setup after loading the view.
  }
  
  @objc func dismissKeyboard(sender: UITapGestureRecognizer) {
    view.endEditing(true)
  }
  
  @objc func keyboardWillShown(notification: Notification) {
    let info = notification.userInfo! as NSDictionary
    let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
    
    kbHeight = kbSize.height
    scrollContentViewTopSpace.constant = kbHeight
    scrollView?.setContentOffset(CGPoint(x: 0, y: kbHeight), animated: true)
  }
  
  @objc func keyboardWillBeHidden(notification: Notification) {
    scrollContentViewTopSpace.constant = 0
    scrollView?.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
  }
  
  @IBAction func close(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func addNewPost(_ sender: Any) {
    var parameters: [String: String] = [:]
    if let message = postText.text {
      parameters["message"] = message
    }
    if let place = self.place {
      parameters["lat"] = "\((place.location?.coordinate.latitude)!)"
      parameters["long"] = "\((place.location?.coordinate.longitude)!)"
    }
    VKService.shared.irrevocableRequest(method: "wall.post", parameters: parameters)
    dismiss(animated: true, completion: nil)
  }
  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    guard place == nil else {
      geostationButton.tintColor = UIColor.darkGray
      place = nil
      return false
    }
    return true
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let destination = segue.destination as? MapViewUIViewController else { return }
    destination.sender = self
  }
  
  func textViewDidBeginEditing(_ textView: UITextView)
  {
    if (postText.text == "Что нового?")
    {
      postText.text = ""
      postText.textColor = .black
    }
    postText.becomeFirstResponder() //Optional
  }
  
  func textViewDidEndEditing(_ textView: UITextView)
  {
    if (postText.text == "")
    {
      postText.text = "Что нового?"
      postText.textColor = .lightGray
    }
    postText.resignFirstResponder()
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}
