//
//  FriendPhotosUICollectionViewController.swift
//  VK Community
//
//  Created by Артем on 03.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import SDWebImage
import RealmSwift

class FriendPhotosUIViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var user: VKUserModel! = nil
    
    var notificationToken: NotificationToken!
    
    // Получение данных о фотографиях пользователя
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        VKRequest(method: "photos.getAll", parameters: ["owner_id": String(user!.id)]) { (response: VKItemsModel<VKPhotoModel>) in
            self.addNewPhotos(newPhotos: response.items, photos: self.user.photos)
            
            self.deleteOldPhotos(newPhotos: response.items, photos: self.user.photos)
        }
    }
    
    func addNewPhotos(newPhotos: [VKPhotoModel], photos: List<VKPhotoModel>) {
        for newPhoto in newPhotos {
            var flag = false
            for photo in photos {
                if newPhoto.isEqual(photo) {
                    flag = true
                    break
                }
            }
            if !flag {
                do {
                    let realm = try Realm()
                    realm.beginWrite()
                    self.user.photos.append(newPhoto)
                    try realm.commitWrite()
                } catch let error {
                    print(error)
                }
            }
        }
    }
    
    func deleteOldPhotos(newPhotos: [VKPhotoModel], photos: List<VKPhotoModel>) {
        for photo in photos {
            var flag = false
            for newPhoto in newPhotos {
                if photo.isEqual(newPhoto) {
                    flag = true
                    break
                }
            }
            if !flag {
                RealmDeleteData([photo])
            }
        }
    }
    
    @IBOutlet weak var userImage: UIImageView! {
        didSet {
            let url = URL(string: user.photo_100)
            userImage.sd_setImage(with: url, completed: nil)
        }
    }
    
    @IBOutlet weak var userFullName: UILabel! {
        didSet {
            userFullName.text = user!.first_name + " " + user!.last_name
        }
    }
    
    @IBOutlet weak var photoCollection: UICollectionView! {
        didSet {
            photoCollection.delegate = self
            photoCollection.dataSource = self
            
            PairCollectionAndData(sender: photoCollection, token: &notificationToken, data: AnyRealmCollection(user.photos))
        }
    }
    
    // Получение количества ячеек для фото
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let photos = user.photos
        return photos.count
    }
    
    // Составление ячеек для фото
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photo = user.photos[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FriendPhotosCollectionViewCell
        
        cell.photo.sd_setImage(with: URL(string: photo.sizes.last!.url), completed: nil)
        
        return cell
    }
    
}
