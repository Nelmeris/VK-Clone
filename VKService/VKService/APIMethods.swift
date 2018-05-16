//
//  APIMethods.swift
//  VKService
//
//  Created by Артем on 15.05.2018.
//  Copyright © 2018 Nelmeris. All rights reserved.
//

// Доступные не возвращаемые методы
public enum Methods: String {
    case friendsGet = "friends.get"
    case groupsGet = "groups.get"
    case groupsSearch = "groups.search"
    case photosGetAll = "photos.getAll"
    
    case groupsLeave = "groups.leave"
    case groupsJoin = "groups.join"
}
