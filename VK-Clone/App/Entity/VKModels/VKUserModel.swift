//
//  VKUserModel.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 09.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import Foundation
import SwiftyJSON

struct VKUserModel: Decodable, Hashable {
    
    let id: Int
    
    let firstName: String
    let lastName: String
    var fullName: String {
        return firstName + " " + lastName
    }
    let avatar: VKAvatarModel
    
    let isOnline: Bool
    let isOnlineMobile: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case isOnline = "online"
        case isOnlineMobile = "online_mobile"
    }
    
    init(from decoder: Decoder) throws {
        if let users = try JSON(from: decoder).array {
            let user = try JSONDecoder().decode(VKUserModel.self, from: try users.first!.rawData())
            id = user.id
            firstName = user.firstName
            lastName = user.lastName
            avatar = user.avatar
            isOnline = user.isOnline
            isOnlineMobile = user.isOnlineMobile
        } else {
            let containers = try decoder.container(keyedBy: CodingKeys.self)
            
            id = try containers.decode(Int.self, forKey: .id)
            firstName = try containers.decode(String.self, forKey: .firstName)
            lastName = try containers.decode(String.self, forKey: .lastName)
            avatar = try VKAvatarModel(from: decoder)
            isOnline = (try? containers.decode(Int.self, forKey: .isOnline) == 1) ?? false
            isOnlineMobile = (try? containers.decode(Int.self, forKey: .isOnlineMobile) == 1) ?? false
        }
    }
    
    static func == (lhs: VKUserModel, rhs: VKUserModel) -> Bool {
        return lhs.id == rhs.id &&
            lhs.fullName == rhs.fullName &&
            lhs.avatar == rhs.avatar &&
            lhs.isOnline == rhs.isOnline &&
            lhs.isOnlineMobile == rhs.isOnlineMobile
    }
    
}
