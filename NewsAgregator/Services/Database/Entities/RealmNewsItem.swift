//
//  RealmNewsItem.swift
//  NewsAgregator
//
//  Created by Sergey Gorin on 28.04.2022.
//

import Foundation
import RealmSwift

class RealmNewsItem: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: String
    @Persisted var source: RealmNewsSource?
    @Persisted var author: String
    @Persisted var title: String
    @Persisted var newsDescription: String
    @Persisted var url: String
    @Persisted var urlToImage: String
    @Persisted var publishedAt: Date
    @Persisted var isAlreadyRead = false
}

extension RealmNewsItem {
    
    convenience init(id: String,
                     source: RealmNewsSource? = nil,
                     author: String = "",
                     title: String = "",
                     newsDescription: String = "",
                     url: String = "",
                     urlToImage: String = "",
                     publishedAt: Date = .distantPast,
                     isAlreadyRead: Bool = false) {
        self.init()
        self.id = id
        self.source = source
        self.author = author
        self.title = title
        self.newsDescription = newsDescription
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.isAlreadyRead = isAlreadyRead
    }
    
    convenience init(article: NewsAPI.Article) {
        self.init()
        let newsSource = RealmNewsSource()
        newsSource.id = article.source.id ?? ""
        newsSource.name = article.source.name ?? ""
        source = newsSource
        author = article.author ?? ""
        title = article.title ?? ""
        newsDescription = article.description ?? ""
        url = article.url ?? ""
        urlToImage = article.urlToImage ?? ""
        publishedAt = article.publishedAt ?? .distantPast
        isAlreadyRead = false
        
        let dateString = Date.ISOStringFromDate(date: publishedAt)
        let string: String = (source?.id ?? "") + author + title + dateString
        id = MD5(string: string)
    }
    
    convenience init(newsItem: NewsItem) {
        self.init()
        self.id = newsItem.id
        let newsSource = RealmNewsSource()
        newsSource.id = newsItem.source.id
        newsSource.name = newsItem.source.name
        self.source = newsSource
        self.author = newsItem.author
        self.title = newsItem.title
        self.newsDescription = newsItem.newsDescription
        self.url = newsItem.url
        self.urlToImage = newsItem.urlToImage
        self.publishedAt = newsItem.publishedAt
        self.isAlreadyRead = newsItem.isAlreadyRead
    }
}
