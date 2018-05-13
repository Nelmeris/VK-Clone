//
//  VKIrretrievableRequests.swift
//  VK Community
//
//  Created by Артем on 11.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

extension VKService {
    
    // Доступные не возвращаемые методы
    enum IrretrievableRequests: String {
        case groupsLeave = "groups.leave"
        case groupsJoin = "groups.join"
    }
    
}
