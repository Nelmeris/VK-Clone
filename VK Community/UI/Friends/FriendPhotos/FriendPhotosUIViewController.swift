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
    
    var user: VKUserModel!
    var userId: Int!
    
    var notificationToken: NotificationToken!
    
    // Получение данных о фотографиях пользователя
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadPhotos()
    }
    
    override func viewDidLoad() {
        DispatchQueue.global().async {
            while true {
                self.loadPhotos()
                sleep(30)
            }
        }
    }
    
    func loadPhotos() {
        VKService.request(method: "photos.getAll", parameters: ["owner_id": String(userId)]) { (response: VKItemsModel<VKPhotoModel>) in
            DispatchQueue.main.async {
                deleteOldPhotos(user: self.user, newPhotos: response.items)
                
                addNewPhotos(user: self.user, newPhotos: response.items)
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

func addNewPhotos(user: VKUserModel, newPhotos: [VKPhotoModel]) {
    for newPhoto in newPhotos {
        var flag = false
        for photo in user.photos {
            if newPhoto.isEqual(photo) {
                flag = true
                break
            }
        }
        if !flag {
            addNewPhoto(user, newPhoto)
        }
    }
}

func addNewPhoto(_ user: VKUserModel, _ newPhoto: VKPhotoModel) {
    do {
        let realm = try Realm()
        realm.beginWrite()
        user.photos.append(newPhoto)
        try realm.commitWrite()
    } catch let error {
        print(error)
    }
}

func deleteOldPhotos(user: VKUserModel, newPhotos: [VKPhotoModel]) {
    for photo in user.photos {
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
