//
//  NewsListStore.swift
//  NewsAgregator
//
//  Created by Sergey Gorin on 29.04.2022.
//

import Foundation
import SwiftUI

struct NewsItemViewModel: Identifiable, Equatable {
    var id: String
    var author: String
    var sourceName: String
    var title: String
    var newsDescription: String
    var url: String
    var urlToImage: String
    var publishedAt: String // Formatted for presenting
    var isAlreadyRead: Bool
}

extension NewsItemViewModel {
    
    init(newsItem: NewsItem) {
        id = newsItem.id
        sourceName = newsItem.source.name
        author = newsItem.author
        title = newsItem.title
        newsDescription = newsItem.newsDescription
        url = newsItem.url
        urlToImage = newsItem.urlToImage
        publishedAt = NewsItem.dateFormatter.string(from: newsItem.publishedAt)
        isAlreadyRead = newsItem.isAlreadyRead
    }
}

enum NewsItemsListError: Swift.Error {
    case any(Error)
}

struct NewsListViewModel {
    
    var items: [NewsItemViewModel] {
        didSet {
            isInitialLoad = oldValue.count == 0
        }
    }
    var error: NewsItemsListError? = nil
    
    private(set) var isInitialLoad = true
}

protocol NewsListPresenterInput: AnyObject {
    func getDestinationView(for item: NewsItemViewModel) -> AnyView
    func getSettingsView() -> AnyView
    func selectPresentSettings()
    func applyFilters()
}

protocol NewListPresenterOutput: AnyObject {
    func add(items: [NewsItemViewModel])
    func handle(error: NewsItemsListError)
}

class NewsListStore: ObservableObject {
    
    enum Action {
        case expandItem(id: String)
        case selectSettings
        case dismissSettings
    }
    
    @Published private(set) var viewModel = NewsListViewModel(items: [])
    @Published private(set) var expandedCells = Set<String>()
    
    @Published var isSettingsViewVisible = false
    
    private var presenter: NewsListPresenterInput
    
    init(presenter: NewsListPresenterInput) {
        self.presenter = presenter
    }
    
    func destinationView(for item: NewsItemViewModel) -> AnyView {
        presenter.getDestinationView(for: item)
    }
    
    func settingsView() -> AnyView {
        presenter.getSettingsView()
    }
    
    func dispatch(action: Action) {
        switch action {
        case .expandItem(let id):
            expandedCells.insert(id)
            
        case .selectSettings:
            isSettingsViewVisible = true
            presenter.selectPresentSettings()
            
        case .dismissSettings:
            presenter.applyFilters()
        }
    }
}

extension NewsListStore: NewListPresenterOutput {
    
    func add(items: [NewsItemViewModel]) {
        viewModel.items = items
    }
    
    func handle(error: NewsItemsListError) {
        viewModel.error = error
    }
}
