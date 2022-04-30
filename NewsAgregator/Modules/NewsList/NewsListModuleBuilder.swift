//
//  NewsListModuleBuilder.swift
//  NewsAgregator
//
//  Created by Sergey Gorin on 29.04.2022.
//

import Foundation
import SwiftUI

class NewsListModuleBuilder {
    
    static func build() -> NewsListView<NewsItem, NewsListPresenter<NewsListInteractor>>  {
        let interactor = NewsListInteractor(service: NewsAPI.shared, database: Realm_NewsDB.shared)
        let router = NewsListRouter()
        let store = NewsListStore<NewsItem>()
        let presenter = NewsListPresenter(store: store, interactor: interactor, router: router)
        return NewsListView(presenter: presenter)
    }
}
