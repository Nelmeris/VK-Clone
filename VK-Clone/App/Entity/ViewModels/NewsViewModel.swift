//
//  NewsViewModel.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 04.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit

struct NewsViewModel {
    let postId: Int?
    let text: String?
    let likes: VKLikesModel?
    let comments: VKCommentsModel?
    let repostsCount: Int?
    let viewsCount: Int?
    let author: (id: Int, name: String, photoUrl: URL?)
    let attachments: [VKAttachmentModel]?
}

final class NewsViewModelFactory {
    
    var profiles: [VKUserModel]! = nil
    var groups: [VKGroupModel]! = nil
    
    func constructViewModels(from newsFeed: VKNewsFeedModel) -> [NewsViewModel] {
        profiles = newsFeed.profiles
        groups = newsFeed.groups
        return newsFeed.news.compactMap(self.viewModel)
    }
    
    private func viewModel(from news: VKNewsModel) -> NewsViewModel {
        let postId = news.postId
        let text = news.text
        let likes = news.likes
        let comments = news.comments
        let repostsCount = news.reposts?.count
        let viewsCount = news.views?.count
        let attachments = news.attachments
        let author = getSourceData(news)
        return NewsViewModel(postId: postId, text: text, likes: likes, comments: comments, repostsCount: repostsCount, viewsCount: viewsCount, author: author, attachments: attachments)
    }
    
    private func getSourceData(_ news: VKNewsModel) -> (id: Int, name: String, photoUrl: URL?) {
        let name: String
        let photoUrl: URL?
        
        if news.sourceId > 0 {
            let source = profiles.filter { profile -> Bool in
                profile.id == news.sourceId
                }.first!
            
            photoUrl = source.avatar.photo100
            name = source.firstName + " " + source.lastName
        } else {
            let source = groups.filter { group -> Bool in
                -group.id == news.sourceId
                }.first!
            
            photoUrl = source.avatar.photo100
            name = source.name
        }
        
        return (news.sourceId, name, photoUrl)
    }
    
}
