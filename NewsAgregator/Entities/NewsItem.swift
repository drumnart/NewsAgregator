//
//  NewsItem.swift
//  NewsAgregator
//
//  Created by Sergey Gorin on 29.04.2022.
//

import Foundation

struct NewsItem: NewsItemViewModel {
    let id: String
    let sourceName: String
    let author: String
    let title: String
    let newsDescription: String // renamed to newsDescription bacause of conflict with standart Description
    let url: String
    let urlToImage: String
    let publishedAt: String // Formatted for presenting
    
    var isAlreadyRead: Bool
    
    init<T: NewsItemModel>(realmNewsItem: T) {
        id = realmNewsItem.id
        sourceName = realmNewsItem.sourceName
        author = realmNewsItem.author
        title = realmNewsItem.title
        newsDescription = realmNewsItem.newsDescription
        url = realmNewsItem.url
        urlToImage = realmNewsItem.urlToImage
        publishedAt = NewsItem.dateFormatter.string(from: realmNewsItem.publishedAt)
        isAlreadyRead = realmNewsItem.isAlreadyRead
    }
}

extension NewsItem {
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
}
