//
//  GalleryViewerViewController.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 15/07/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import UIKit
import SDWebImage

class GalleryViewerViewController: UIViewController {
    
    var scrollView: UIScrollView!
    
    var images: [VKPhotoModel]!
    var selectImageId: Int!
    var imageViews = [UIImageView]()
    
    required init(images: [VKPhotoModel], selectImageId: Int) {
        super.init(nibName: nil, bundle: nil)
        self.images = images
        self.selectImageId = selectImageId
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setImages() {
        for image in images {
            let imageView = UIImageView()
            imageView.sd_setImage(with: image.sizes.last!.url, completed: nil)
            imageView.contentMode = .scaleAspectFit
            scrollView.addSubview(imageView)
            imageViews.append(imageView)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initScrollView()
        setImages()
        self.view.backgroundColor = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = .black
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.barTintColor = UINavigationBar.appearance().barTintColor
    }
    
    private func initScrollView() {
        scrollView = UIScrollView()
        self.view.addSubview(scrollView)
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = self.view.bounds
        let width = scrollView.frame.width
        for (index, imageView) in imageViews.enumerated() {
            imageView.frame.size = scrollView.frame.size
            imageView.frame.origin.x = width * CGFloat(index)
            imageView.frame.origin.y = 0
        }
        let contentWidth = scrollView.frame.width * CGFloat(imageViews.count)
        scrollView.contentSize = CGSize(width: contentWidth, height: scrollView.frame.height)
        scrollView.contentOffset = CGPoint(x: width * CGFloat(selectImageId), y: 0)
    }
    
}
