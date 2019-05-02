//
//  VKServicePhotoModel.swift
//  VK X
//
//  Created by Artem Kufaev on 11.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import RealmSwift

struct VKPhotosModel: Decodable {
  var photos: [VKPhotoModel]

  enum CodingKeys: String, CodingKey {
    case photos = "items"
  }

  init(from decoder: Decoder) throws {
    let containers = try decoder.container(keyedBy: CodingKeys.self)

    photos = try containers.decode([VKPhotoModel].self, forKey: .photos)
  }
}

class VKPhotoModel: RealmModel {
  @objc dynamic var id = 0

  var sizes = List<VKSizeModel>()

  enum CodingKeys: String, CodingKey {
    case id
    case sizes
  }

  required convenience init(from decoder: Decoder) throws {
    self.init()

    let containers = try decoder.container(keyedBy: CodingKeys.self)

    id = try containers.decode(Int.self, forKey: .id)
    let sizes = try containers.decode([VKSizeModel].self, forKey: .sizes)
    self.sizes.append(objectsIn: sizes)
  }

  override func isEqual (_ object: RealmModel) -> Bool {
    guard let newPhotos = object as? VKPhotoModel else { return false }

    guard id == newPhotos.id && self.sizes.count == newPhotos.sizes.count else { return false }

    let sizes = self.sizes.sorted(byKeyPath: "id")
    let newSizes = newPhotos.sizes.sorted(byKeyPath: "id")

    for (index, size) in sizes.enumerated() {
      guard size.isEqual(newSizes[index]) else { return false }
    }

    return true
  }
}
