//
//  NewsListPresenter_Previews.swift
//  NewsAgregator
//
//  Created by Sergey Gorin on 29.04.2022.
//

import Foundation
import SwiftUI

final class NewsListPresenter_Previews<T: NewsListInteractorProtocol>: NewsListPresenterProtocol {
    private let interactor: T
    private let router: NewsListRouterProtocol
    
    var store = NewsListStore<NewsItem>()
    
    init(interactor: T, router: NewsListRouterProtocol) {
        self.interactor = interactor
        self.router = router
        
        let calendar = Calendar.current
        let dateComponents = DateComponents(calendar: calendar, year: 2022, month: 4, day: 26, hour: 16, minute: 05, second: 28)
        let sampleArticle1 = NewsAPI.Article(
            source: NewsAPI.Source(id: "the-verge", name: "the-verge"),
            author: "Jon Porter",
            title: "Emoji reactions are sliding into Twitter’s DMs - The Verge",
            description: "Twitter’s direct messages now support emoji reactions. To use them, you can either tap the small “heart and plus icon” that appears to the right of messages you receive, or double tap a message on mobile.",
            url: "",
            urlToImage: "https://s.abcnews.com/images/Business/WireAP_6b82fe19ed404b0b8e96c9f4c9371e7c_16x9_992.jpg",
            publishedAt: calendar.date(from: dateComponents),
            content: ""
        )
        
        let dbItem = RealmNewsItem(article: sampleArticle1)
        store.newsItems = [NewsItem(realmNewsItem: dbItem)]
    }
    
    func getDstinationView(for item: NewsItem) -> AnyView {
        return AnyView(NewsDetailsView_Previews.previews)
    }
    
    func presentSettings() {}
}
