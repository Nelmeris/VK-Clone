//
//  NewsCell.swift
//  VK Community
//
//  Created by Артем on 28.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    @IBOutlet weak var authorPhoto: UIImageView! {
        didSet {
            authorPhoto.layer.cornerRadius = authorPhoto.frame.height / 2
        }
    }
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var likesCount: UILabel!
    @IBOutlet weak var repostsCount: UILabel!
    @IBOutlet weak var commentsCount: UILabel!
    @IBOutlet weak var viewsCount: UILabel!
}
