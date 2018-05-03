//
//  User.swift
//  VK Community
//
//  Created by Артем on 03.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

class User {
    let firstName: String
    let lastName: String
    let photos: [String]
    
    init(firstName: String, lastName: String, photos: [String]) {
        self.firstName = firstName
        self.lastName = lastName
        self.photos = photos
    }
}
