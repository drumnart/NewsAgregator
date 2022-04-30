//
//  NewsListPresenter.swift
//  NewsAgregator
//
//  Created by Sergey Gorin on 25.04.2022.
//

import Foundation
import Combine
import SwiftUI

protocol NewsItemModel: Identifiable, Equatable {
    var id: String { get }
    var sourceName: String { get }
    var author: String { get }
    var title: String { get }
    var newsDescription: String { get }
    var url: String { get }
    var urlToImage: String { get }
    var publishedAt: Date { get }
    var isAlreadyRead: Bool { get set }
}

protocol NewsListInteractorProtocol {
    
    associatedtype T: NewsItemModel
    
    var newsItemsPublisher: Published<[T]>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    
    func markAsReadNewsItem(item: NewsItem)
}

protocol NewsListRouterProtocol {
    func presentDetailsScreen(item: NewsItem, onAppear: (() -> Void)?) -> AnyView
}

final class NewsListPresenter<T>: NewsListPresenterProtocol where T: NewsListInteractorProtocol {
    
    private var interactor: T
    private var router: NewsListRouterProtocol
    
    private(set) var store = NewsListStore<NewsItem>()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(store: NewsListStore<NewsItem>, interactor: T, router: NewsListRouterProtocol) {
        self.store = store
        self.interactor = interactor
        self.router = router
        
        interactor.newsItemsPublisher
            .sink { [weak self] items in
                self?.store.newsItems = items.map { NewsItem(realmNewsItem: $0) }
            }
            .store(in: &cancellables)
    }
     
    func getDstinationView(for item: NewsItem) -> AnyView {
        return router.presentDetailsScreen(item: item, onAppear: { [weak self] in
            self?.interactor.markAsReadNewsItem(item: item)
        })
    }
    
    func presentSettings() {
        
    }
}
