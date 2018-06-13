//
//  FriendPhotosUIViewController.swift
//  VK Community
//
//  Created by Артем on 03.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import SDWebImage
import RealmSwift

class FriendPhotosUIViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var user: VKUserModel!
    var userId: Int!
    
    var notificationToken: NotificationToken!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadPhotos()
    }
    
    @IBOutlet weak var userImage: UIImageView! {
        didSet {
            let url = URL(string: user.photo100)
            userImage.sd_setImage(with: url, completed: nil)
            userImage.layer.cornerRadius = userImage.frame.height / 2
        }
    }
    
    @IBOutlet weak var userFullName: UILabel! {
        didSet {
            userFullName.text = user.firstName + " " + user.lastName
        }
    }
    
    @IBOutlet weak var photoCollection: UICollectionView! {
        didSet {
            photoCollection.delegate = self
            photoCollection.dataSource = self
            
            RealmService.pairCollectionViewAndData(sender: photoCollection, token: &notificationToken, data: AnyRealmCollection(user.photos))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let photos = user.photos
        return photos.count
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
        VKService.request(method: "photos.getAll", parameters: ["owner_id": String(userId)]) { (response: VKItemsModel<VKPhotoModel>) in
            DispatchQueue.main.async {
                FriendPhotosUIViewController.deleteOldPhotos(user: self.user, newPhotos: response.items)
                
                FriendPhotosUIViewController.addNewPhotos(user: self.user, newPhotos: response.items)
            }
        }
    }
    
    
    
    static func addNewPhotos(user: VKUserModel, newPhotos: [VKPhotoModel]) {
        for newPhoto in newPhotos {
            if !user.photos.contains(newPhoto) {
                addNewPhoto(user, newPhoto)
            }
        }
    }
    
    static func addNewPhoto(_ user: VKUserModel, _ newPhoto: VKPhotoModel) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            user.photos.append(newPhoto)
            try realm.commitWrite()
        } catch let error {
            print(error)
        }
    }
    
    static func deleteOldPhotos(user: VKUserModel, newPhotos: [VKPhotoModel]) {
        for photo in user.photos {
            if !newPhotos.contains(photo) {
                RealmService.deleteData([photo])
            }
        }
    }
    
}
