//
//  VKVideoModel.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 03/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Foundation

struct VKVideoModel: Decodable {
    let id: Int
    let ownerId: Int
    let title: String
    let description: String
    let duration: Int
    
    let previewPhotos: VKVideoPreviewsModel
    let firstFrames: VKVideoFirstFramesModel
    
    let creatingDate: Date
    let addingDate: Date?
    
    let views: Int
    let comments: Int
    
    let source: URL?
    let platform: String?
    
    let canEdit: Bool
    let canAdd: Bool
    let isPrivate: Bool
    
    let accessKey: String
    let isProcessing: Bool
    let isLive: Bool
    let isUpcoming: Bool
    let isFavorite: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerId = "owner_id"
        case title, description, duration
        case creatingDate = "date"
        case addingDate = "adding_date"
        case views, comments
        case source = "player"
        case platform
        
        case canEdit = "can_edit"
        case canAdd = "can_add"
        case isPrivate = "is_private"
        
        case accessKey = "access_key"
        case isProcessing = "processing"
        case isLive = "live"
        case isUpcoming = "upcoming"
        case isFavorite = "is_favorite"
    }
    
    init(from decoder: Decoder) throws {
        let containers = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try containers.decode(Int.self, forKey: .id)
        ownerId = try containers.decode(Int.self, forKey: .ownerId)
        title = try containers.decode(String.self, forKey: .title)
        description = try containers.decode(String.self, forKey: .description)
        duration = try containers.decode(Int.self, forKey: .duration)
        
        previewPhotos = try VKVideoPreviewsModel(from: decoder)
        firstFrames = try VKVideoFirstFramesModel(from: decoder)
        
        creatingDate = Date(timeIntervalSince1970: try TimeInterval(containers.decode(Int.self, forKey: .creatingDate)))
        if let date = try? containers.decode(Int.self, forKey: .addingDate) {
            addingDate = Date(timeIntervalSince1970: TimeInterval(date))
        } else {
            addingDate = nil
        }
        
        views = try containers.decode(Int.self, forKey: .views)
        comments = try containers.decode(Int.self, forKey: .comments)
        
        if let source = try? containers.decode(String.self, forKey: .source) {
            self.source = URL(string: source)!
        } else {
            source = nil
        }
        if let platform = try? containers.decode(String.self, forKey: .platform) {
            self.platform = platform
        } else {
            platform = nil
        }
        
        canEdit = (try? containers.decode(Int.self, forKey: .canEdit) == 1) ?? false
        canAdd = try containers.decode(Int.self, forKey: .canAdd) == 1
        isPrivate = (try? containers.decode(Int.self, forKey: .isPrivate) == 1) ?? false
        
        accessKey = try containers.decode(String.self, forKey: .accessKey)
        isProcessing = (try? containers.decode(Int.self, forKey: .isProcessing) == 1) ?? false
        isLive = (try? containers.decode(Int.self, forKey: .isLive) == 1) ?? false
        isUpcoming = (try? containers.decode(Int.self, forKey: .isUpcoming) == 1) ?? false
        isFavorite = try containers.decode(Bool.self, forKey: .isFavorite)
    }
}

struct VKVideoFirstFramesModel: Decodable {
    let frame130: VKPhotoWithSizeModel?
    let frame320: VKPhotoWithSizeModel?
    let frame640: VKPhotoWithSizeModel?
    let frame800: VKPhotoWithSizeModel?
    let frame1280: VKPhotoWithSizeModel?
    
    enum CodingKeys: String, CodingKey {
        case frame130 = "first_frame_130"
        case frame320 = "first_frame_320"
        case frame640 = "first_frame_640"
        case frame800 = "first_frame_800"
        case frame1280 = "first_frame_1280"
    }
    
    init(from decoder: Decoder) throws {
        let containers = try decoder.container(keyedBy: CodingKeys.self)
        if let url = URL(string: (try? containers.decode(String.self, forKey: .frame130)) ?? "") {
            frame130 = VKPhotoWithSizeModel(url: url, width: 130, height: 98)
        } else { frame130 = nil }
        if let url = URL(string: try containers.decode(String.self, forKey: .frame320)) {
            frame320 = VKPhotoWithSizeModel(url: url, width: 320, height: 240)
        } else { frame320 = nil }
        if let url = URL(string: (try? containers.decode(String.self, forKey: .frame640)) ?? "") {
            frame640 = VKPhotoWithSizeModel(url: url, width: 640, height: 480)
        } else { frame640 = nil }
        if let url = URL(string: (try? containers.decode(String.self, forKey: .frame800)) ?? "") {
            frame800 = VKPhotoWithSizeModel(url: url, width: 800, height: 450)
        } else { frame800 = nil }
        if let url = URL(string: (try? containers.decode(String.self, forKey: .frame1280)) ?? "") {
            frame1280 = VKPhotoWithSizeModel(url: url, width: 1280, height: 720)
        } else { frame1280 = nil }
    }
}

struct VKVideoPreviewsModel: Decodable {
    let photo130: VKPhotoWithSizeModel?
    let photo320: VKPhotoWithSizeModel?
    let photo640: VKPhotoWithSizeModel?
    let photo800: VKPhotoWithSizeModel?
    let photo1280: VKPhotoWithSizeModel?
    
    enum CodingKeys: String, CodingKey {
        case photo130 = "photo_130"
        case photo320 = "photo_320"
        case photo640 = "photo_640"
        case photo800 = "photo_800"
        case photo1280 = "photo_1280"
    }
    
    init(from decoder: Decoder) throws {
        let containers = try decoder.container(keyedBy: CodingKeys.self)
        if let url = URL(string: (try? containers.decode(String.self, forKey: .photo130)) ?? "") {
            photo130 = VKPhotoWithSizeModel(url: url, width: 130, height: 98)
        } else { photo130 = nil }
        if let url = URL(string: try containers.decode(String.self, forKey: .photo320)) {
            photo320 = VKPhotoWithSizeModel(url: url, width: 320, height: 240)
        } else { photo320 = nil }
        if let url = URL(string: (try? containers.decode(String.self, forKey: .photo640)) ?? "") {
            photo640 = VKPhotoWithSizeModel(url: url, width: 640, height: 480)
        } else { photo640 = nil }
        if let url = URL(string: (try? containers.decode(String.self, forKey: .photo800)) ?? "") {
            photo800 = VKPhotoWithSizeModel(url: url, width: 800, height: 450)
        } else { photo800 = nil }
        if let url = URL(string: (try? containers.decode(String.self, forKey: .photo1280)) ?? "") {
            photo1280 = VKPhotoWithSizeModel(url: url, width: 1280, height: 720)
        } else { photo1280 = nil }
    }
}

struct VKPhotoWithSizeModel: Decodable {
    let url: URL
    let width: Int
    let height: Int
}
