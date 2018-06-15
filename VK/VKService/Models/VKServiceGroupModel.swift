//
//  VKServiceGroupModel.swift
//  VK X
//
//  Created by Artem Kufaev on 10.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import SwiftyJSON

class VKGroupsResponseModel: VKBaseModel {
  var response: [VKGroupModel] = []
  
  required convenience init(_ json: JSON) {
    self.init()
    
    response = json.map { VKGroupModel($0.1) }
  }
}

class VKGroupModel: RealmModel {
  @objc dynamic var id = 0
  @objc dynamic var name = ""
  @objc dynamic var photo100 = ""
  @objc dynamic var membersCount = 0
  
  required convenience init(_ json: JSON) {
    self.init()
    
    id = json["id"].intValue
    name = json["name"].stringValue
    photo100 = json["photo_100"].stringValue
    membersCount = json["members_count"].intValue
  }
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  override func isEqual (_ object: RealmModel) -> Bool {
    let object = object as! VKGroupModel
    return (id == object.id) &&
      (name == object.name) &&
      (photo100 == object.photo100) &&
      (membersCount == object.membersCount)
  }
}
