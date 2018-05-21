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
        VKRequest(sender: self, method: .photosGetAll, parameters: ["owner_id": String(user!.id)], completion: { (response: VKModels<VKPhoto>) in
            let realm = try! Realm()
            try! realm.write {
                for item in response.items {
                    realm.delete(realm.objects(VKPhoto.self).filter("id = %@", item.id))
                }
                self.user!.photos.removeAll()
                for item in response.items {
                    self.user!.photos.append(item)
                }
            }
            print(self.user!.photos)
            UpdatingData([self.user!])
        })
    }
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var photoCollection: UICollectionView!
    
    override func viewDidLoad() {
        photoCollection.delegate = self
        photoCollection.dataSource = self
        
        let url = URL(string: user!.photo_100)
        userImage.sd_setImage(with: url, completed: nil)
        
        userFullName.text = user!.first_name + " " + user!.last_name
        
        let users: Results<VKUser> = LoadData()!
        let index = users.index(of: user!)
        photos = users[index!].photos
        
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
