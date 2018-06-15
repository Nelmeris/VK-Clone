//
//  VKServiceUserModel.swift
//  VK X
//
//  Created by Artem Kufaev on 09.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import SwiftyJSON
import RealmSwift

class VKUsersResponseModel: VKBaseModel {
  var response: [VKUserModel] = []
  var items: [VKUserModel] = []
  var photos: [[VKPhotoModel]] = [[]]
  
  required convenience init(_ json: JSON) {
    self.init()
    
    response = json.map { VKUserModel($0.1) }
    items = json["items"].map { VKUserModel($0.1) }
    photos = json["photos"].map { $0.1["items"].map { VKPhotoModel($0.1) } }
  }
}

class VKUserModel: RealmModel {
  @objc dynamic var id = 0
  @objc dynamic var firstName = ""
  @objc dynamic var lastName = ""
  @objc dynamic var photo100 = ""
  @objc dynamic var isOnline = false
  @objc dynamic var isOnlineMobile = false
  
  var photos = List<VKPhotoModel>()
  
  required convenience init(_ json: JSON) {
    self.init()
    
    id = json["id"].intValue
    firstName = json["first_name"].stringValue
    lastName = json["last_name"].stringValue
    photo100 = json["photo_100"].stringValue
    isOnline = json["online"].intValue != 0
    isOnlineMobile = json["online_mobile"].intValue != 0
  }
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  override func isEqual (_ object: RealmModel) -> Bool {
    let object = object as! VKUserModel
    return (id == object.id) &&
      (firstName == object.firstName) &&
      (lastName == object.lastName) &&
      (photo100 == object.photo100) &&
      (isOnline == object.isOnline) &&
      (isOnlineMobile == object.isOnlineMobile) &&
      (photos.isEqual(object.photos))
  }
}
