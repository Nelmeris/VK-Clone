//
//  FriendPhotosViewController.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 03.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit
import SDWebImage

class FriendPhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var userImage: RoundImageView!
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var photoCollection: UICollectionView!
    
    var user: VKUserModel!
    var photos = [VKPhotoModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImage.sd_setImage(with: user.avatar.photo100, completed: nil)
        
        userFullName.text = user.fullName
        
        self.hidesBottomBarWhenPushed = true
        
        photoCollection.delegate = self
        photoCollection.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPhotos()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photo = photos[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FriendPhotosCollectionViewCell
        
        cell.photo.sd_setImage(with: photo.sizes.last!.url, completed: nil)
        
        return cell
    }
    
    func loadPhotos() {
        VKService.shared.getOwnerPhotos(ownerId: user.id) { [weak self] photos in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.photos = photos
                strongSelf.photoCollection.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = GalleryViewerViewController(images: photos, selectImageId: indexPath.row)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
