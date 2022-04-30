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
    
    convenience init(article: NewsAPI.Article) {
        self.init()
        let newSource = RealmNewsSource()
        newSource.id = article.source.id ?? ""
        newSource.name = article.source.name ?? ""
        source = newSource
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
}

extension RealmNewsItem: NewsItemModel {
    
    var sourceName: String { source?.name ?? "" }
    
    func update(from item: NewsItem) {
        source?.name = item.sourceName
        author = item.author
        title = item.title
        newsDescription = item.newsDescription
        url = item.url
        urlToImage = item.urlToImage
        isAlreadyRead = item.isAlreadyRead
    }
}
