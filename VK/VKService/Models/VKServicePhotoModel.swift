//
//  VKServicePhotoModel.swift
//  VK X
//
//  Created by Artem Kufaev on 11.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import SwiftyJSON
import RealmSwift

class VKPhotoModel: RealmModel {
  @objc dynamic var id = 0
  var sizes = List<VKSizesModel>()
  
  required convenience init(_ json: JSON) {
    self.init()
    
    id = json["id"].intValue
    
    let sizes = json["sizes"].map { VKSizesModel($0.1) }
    
    sizes.forEach { size in
      self.sizes.append(size)
    }
  }
  
  override func isEqual (_ object: RealmModel) -> Bool {
    let object = object as! VKPhotoModel
    
    guard sizes.count == object.sizes.count else { return false }
    
    for (index, size) in sizes.enumerated() {
      guard size.isEqual(object.sizes[index]) else { return false }
    }
    
    return id == object.id
  }
}
