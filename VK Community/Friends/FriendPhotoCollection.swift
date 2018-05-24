//
//  PhotoCollection.swift
//  VK Community
//
//  Created by Артем on 03.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import SDWebImage
import RealmSwift

class FriendPhotoCollection: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var user: VKUser? = nil
    
    var photos: List<VKPhoto>?
    var notificationToken: NotificationToken?
    
    // Получение данных о фотографиях пользователя
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        VKRequest(sender: self, method: .photosGetAll, parameters: ["owner_id": String(user!.id)], completion: { (response: VKModels<VKPhoto>) in
            for responseUserPhoto in response.items {
                var flag = false
                for userPhoto in self.user!.photos {
                    if responseUserPhoto.isEqual(userPhoto) {
                        flag = true
                        break
                    }
                }
                if !flag {
                    do {
                        let realm = try Realm()
                        realm.beginWrite()
                        self.user!.photos.append(responseUserPhoto)
                        try realm.commitWrite()
                    } catch {}
                }
            }
            for userPhoto in self.user!.photos {
                var flag = false
                for responseUserPhoto in response.items {
                    if userPhoto.isEqual(responseUserPhoto) {
                        flag = true
                        break
                    }
                }
                if !flag {
                    DeleteData([userPhoto])
                }
            }
        })
    }
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var photoCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoCollection.delegate = self
        photoCollection.dataSource = self
        
        let url = URL(string: user!.photo_100)
        userImage.sd_setImage(with: url, completed: nil)
        
        userFullName.text = user!.first_name + " " + user!.last_name
        
        photos = user!.photos
        
        PairCollectionAndData(sender: photoCollection, token: &notificationToken, data: AnyRealmCollection(photos!))
    }
    
    // Получение количества ячеек для фото
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }
    
    // Составление ячеек для фото
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FriendPhotoCollectionCell
        
        let url = URL(string: photos![indexPath.row].photo_130)
        cell.photo.sd_setImage(with: url, completed: nil)
        
        return cell
    }
    
}
