//
//  APIMethods.swift
//  VKService
//
//  Created by Артем on 15.05.2018.
//  Copyright © 2018 Nelmeris. All rights reserved.
//

// Доступные методы
public enum Methods: String {
    // Возвращаемые
    case friendsGet = "friends.get"
    case groupsGet = "groups.get"
    case groupsSearch = "groups.search"
    case photosGetAll = "photos.getAll"
    
    // Не возвращаемые
    case groupsLeave = "groups.leave"
    case groupsJoin = "groups.join"
}
