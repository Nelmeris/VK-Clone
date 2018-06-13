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
        
        VKService.methods.getUser(id: userId) { response in
            do {
                let realm = try Realm()
                realm.beginWrite()
                self.user.photos = response.photos
                try realm.commitWrite()
            } catch let error {
                print(error)
            }
        }
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
