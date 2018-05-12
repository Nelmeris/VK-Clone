//
//  PhotoCollection.swift
//  VK Community
//
//  Created by Артем on 03.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import SDWebImage

class FriendPhotoCollection: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var photos = [VKService.Structs.Photo]()
    var user = VKService.Structs.Friend(json: nil)
    
    // Получение данных о фотографиях пользователя
    override func viewWillAppear(_ animated: Bool) {
        VKService.Requests.photos.getAll(sender: self, version: .v5_74, parameters: ["owner_id": String(user.id)], completion: { response in
            self.photos = response.items
            self.photoCollection.reloadData()
        })
    }
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var photoCollection: UICollectionView!
    
    // Получение количества ячеек для фото
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func viewDidLoad() {
        photoCollection.delegate = self
        photoCollection.dataSource = self
        
        let url = URL(string: user.photo_100)
        userImage.sd_setImage(with: url, completed: nil)
        
        userFullName.text = user.first_name + " " + user.last_name
    }
    
    // Составление ячеек для фото
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FriendPhotoCollectionCell
        
        let url = URL(string: photos[indexPath.row].photo_130)
        cell.photo.sd_setImage(with: url, completed: nil)
        
        return cell
    }
    
}
