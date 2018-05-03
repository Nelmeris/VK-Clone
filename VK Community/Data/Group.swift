//
//  Group.swift
//  VK Community
//
//  Created by Артем on 03.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

class Group {
    let name: String
    let photo: String
    let participantsCount: Int
    
    init(name: String, photo: String, participantsCount: Int) {
        self.name = name
        self.photo = photo
        self.participantsCount = participantsCount
    }
}
