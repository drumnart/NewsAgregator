//
//  NewsItem.swift
//  NewsAgregator
//
//  Created by Sergey Gorin on 29.04.2022.
//

import Foundation

struct NewsItem: Identifiable {
    
    struct Source: Identifiable {
        let id: String
        let name: String
    }
    
    let id: String
    let source: Source
    let author: String
    let title: String
    let newsDescription: String // renamed to newsDescription bacause of conflict with standart Description
    let url: String
    let urlToImage: String
    let publishedAt: Date
    
    var isAlreadyRead: Bool
}

extension NewsItem {
    
    init(realmNewsItem: RealmNewsItem) {
        id = realmNewsItem.id
        source = NewsItem.Source(id: realmNewsItem.source?.id ?? "",
                                 name: realmNewsItem.source?.name ?? "")
        author = realmNewsItem.author
        title = realmNewsItem.title
        newsDescription = realmNewsItem.newsDescription
        url = realmNewsItem.url
        urlToImage = realmNewsItem.urlToImage
        publishedAt = realmNewsItem.publishedAt
        isAlreadyRead = realmNewsItem.isAlreadyRead
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
}
