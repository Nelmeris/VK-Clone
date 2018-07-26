//
//  NewPostUIViewController.swift
//  VK X
//
//  Created by Artem Kufaev on 26/07/2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import MapKit

class NewPostUIViewController: UIViewController {
  
  @IBOutlet weak var postText: UITextField!
  var place: CLPlacemark?
  
  @IBOutlet weak var geostationButton: UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
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
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}
