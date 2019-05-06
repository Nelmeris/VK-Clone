//
//  VKGeoModel.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 05/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Foundation
import GoogleMaps

struct VKGeoModel: Decodable {
    let type: String
    let coordinates: CLLocationCoordinate2D
    let place: VKGeoPlaceModel
    
    enum CodingKeys: String, CodingKey {
        case type
        case coordinates
        case place
    }
}

struct VKGeoPlaceModel: Decodable {
    let id: Int
    let title: String
    let latitude: Int
    let longitude: Int
    let createdDate: Date
    let iconUrl: URL
    let country: String
    let city: String
    
    let type: Int?
    let groupId: Int?
    let groupPhoto: URL?
    let checkinsCount: Int?
    let updatedDate: Date?
    let address: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, title, latitude, longitude, createdDate = "created"
        case iconUrl = "icon"
        case country, city
        
        case type
        case groupId = "group_id"
        case groupPhoto = "group_photo"
        case checkinsCount = "checkins"
        case updatedDate = "updated"
        case address
    }
    
    init(from decoder: Decoder) throws {
        let containers = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try containers.decode(Int.self, forKey: .id)
        title = try containers.decode(String.self, forKey: .title)
        latitude = try containers.decode(Int.self, forKey: .latitude)
        longitude = try containers.decode(Int.self, forKey: .longitude)
        createdDate = Date(timeIntervalSinceNow: TimeInterval(try containers.decode(Int.self, forKey: .createdDate)))
        iconUrl = URL(string: try containers.decode(String.self, forKey: .iconUrl))!
        country = try containers.decode(String.self, forKey: .country)
        city = try containers.decode(String.self, forKey: .city)
        
        type = try? containers.decode(Int.self, forKey: .type)
        groupId = try? containers.decode(Int.self, forKey: .groupId)
        groupPhoto = URL(string: (try? containers.decode(String.self, forKey: .groupPhoto)) ?? "")
        checkinsCount = try? containers.decode(Int.self, forKey: .checkinsCount)
        if let updatedDateInt = try? containers.decode(Int.self, forKey: .type) {
            updatedDate = Date(timeIntervalSinceNow: TimeInterval(updatedDateInt))
        } else {
            updatedDate = nil
        }
        address = try? containers.decode(Int.self, forKey: .address)
    }
}

extension CLLocationCoordinate2D: Decodable {
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
    
    public init(from decoder: Decoder) throws {
        self.init()
        let containers = try decoder.container(keyedBy: CodingKeys.self)
        self.latitude = CLLocationDegrees(try containers.decode(Int.self, forKey: .latitude))
        self.longitude = CLLocationDegrees(try containers.decode(Int.self, forKey: .longitude))
    }
}
