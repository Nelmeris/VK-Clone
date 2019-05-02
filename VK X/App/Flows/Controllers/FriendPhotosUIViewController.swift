//
//  FriendPhotosUIViewController.swift
//  VK X
//
//  Created by Artem Kufaev on 03.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit
import SDWebImage
import RealmSwift

class FriendPhotosUIViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

  @IBOutlet weak var userImage: RoundUIImageView!
  @IBOutlet weak var userFullName: UILabel!
  @IBOutlet weak var photoCollection: UICollectionView!

  var user: VKUserModel!

  var notificationToken: NotificationToken!

  override func viewDidLoad() {
    super.viewDidLoad()

    userImage.sd_setImage(with: URL(string: user.photo), completed: nil)

    userFullName.text = user.firstName + " " + user.lastName

    photoCollection.delegate = self
    photoCollection.dataSource = self

    RealmService.shared.pairCollectionViewAndData(sender: photoCollection, token: &notificationToken, data: AnyRealmCollection(user.photos))
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    loadPhotos()
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return user.photos.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let photo = user.photos[indexPath.row]
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FriendPhotosCollectionViewCell

    cell.photo.sd_setImage(with: URL(string: photo.sizes.last!.url), completed: nil)

    return cell
  }

}

extension FriendPhotosUIViewController {

  func loadPhotos() {
    VKService.Methods.Photos.getAll(ownerId: user.id) { [weak self] photos in
      guard let strongSelf = self else { return }
      FriendPhotosUIViewController.updatePhotos(user: strongSelf.user, newPhotos: photos)
    }
  }

  static func updatePhotos(user: VKUserModel, newPhotos: [VKPhotoModel]) {
    do {
      let realm = try Realm()
      realm.beginWrite()
      var i = 0
      for (index, photo) in user.photos.enumerated() {
        guard !newPhotos.contains(photo) else { continue }

        user.photos.remove(at: index - i)
        i += 1
      }
      for newPhoto in newPhotos {
        guard !user.photos.contains(newPhoto) else { continue }

        user.photos.append(newPhoto)
      }
      try realm.commitWrite()
    } catch let error {
      print(error)
    }
  }
}
