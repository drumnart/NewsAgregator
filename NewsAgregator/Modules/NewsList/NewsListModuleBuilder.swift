//
//  NewsListModuleBuilder.swift
//  NewsAgregator
//
//  Created by Sergey Gorin on 29.04.2022.
//

import Foundation
import SwiftUI

class NewsListModuleBuilder {
    
    static func build() -> NewsListView {
        let database = Realm_NewsDB.shared
        let serviceWorker = APIServiceWorker(apiService: NewsAPI.shared, delegate: database)
        let interactor = NewsListInteractor(apiServiceWorker: serviceWorker, databaseService: database)
        let router = NewsListRouter()
        let presenter = NewsListPresenter(interactor: interactor, router: router)
        let store = NewsListStore(presenter: presenter)
        presenter.setup(output: store)
        interactor.setup(output: presenter)
        return NewsListView(store: store)
    }
}
