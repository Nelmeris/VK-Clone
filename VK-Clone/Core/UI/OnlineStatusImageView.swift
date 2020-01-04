//
//  OnlineStatusUIImageView.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 15/06/2018.
//  Copyright © Artem Kufaev. All rights reserved.
//

import UIKit

class OnlineStatusUIImageView: UIImageView {
    
    @IBOutlet weak var onlineStatusIconHeight: NSLayoutConstraint!
    @IBOutlet weak var onlineStatusIconWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        image = nil
    }
    
    func initial(_ onlineType: OnlineType) {
        guard onlineType != .offline else { return }
        
        image = (onlineType == .mobile ? #imageLiteral(resourceName: "OnlineMobileIcon") : #imageLiteral(resourceName: "OnlineIcon"))
        self.backgroundColor = UIColor.white
        
        onlineStatusIconWidth.constant = 40 / (onlineType == .mobile ? 4.5 : 4)
        onlineStatusIconHeight.constant = 40 / (onlineType == .mobile ? 3.5 : 4)
        
        layer.cornerRadius = 40 / (onlineType == .mobile ? 15 : 8)
    }
    
}
