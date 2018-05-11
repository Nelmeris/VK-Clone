//
//  PhotoCollection.swift
//  VK Community
//
//  Created by Артем on 03.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit

class FriendPhotoCollection: UICollectionViewController {
    
    var photos = [VKService.Structs.Photo]()
    var userID = 0
    
    // Получение данных о фотографиях пользователя
    override func viewWillAppear(_ animated: Bool) {
        VKService.Requests.photos.getAll(sender: self, version: .v5_74, parameters: ["owner_id": String(userID)], completion: { response in
            self.photos = response.items
            self.collectionView?.reloadData()
        })
    }
    
    // Получение количества ячеек для фото
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    // Составление ячеек для фото
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FriendPhotoCollectionCell
        
        let url = URL(string: photos[indexPath.row].photo_75)
        let data = try! Data(contentsOf: url!)
        cell.photo.image = UIImage(data: data)
        
        return cell
    }
}
