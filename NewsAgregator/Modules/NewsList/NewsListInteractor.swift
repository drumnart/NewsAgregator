//
//  NewsListInteractor.swift
//  NewsAgregator
//
//  Created by Sergey Gorin on 25.04.2022.
//

import Foundation
import Combine

class NewsListInteractor {
    
    @Published var news: [RealmNewsItem] = []
    @Published var error: Error? = nil
    
    var newsItemsPublisher: Published<[RealmNewsItem]>.Publisher { $news }
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    private var service: NewsAPIProtocol
    private var database: NewsDBProtocol
    
    private var cancellable: Set<AnyCancellable> = []
    
    private var timer: Timer?
    
    // Fetching data frequency
    // TODO: Move to Settings
    private var scheduledTimerInterval: TimeInterval = 20
    
    init(service: NewsAPIProtocol , database: NewsDBProtocol) {
        self.service = service
        self.database = database
        
        subscribeOnDBChanges()
        loadData()
    }
    
    deinit {
        cancelTimer()
    }
    
    func loadData() {
        fetchItemsFromDB()
        fetchItemsFromService()
    }
    
    func fetchItemsFromDB() {
        database.fetch()
            .sink(
                receiveCompletion: { [unowned self] (completion) in
                    if case let .failure(error) = completion {
                        self.error = error
                    }},
                receiveValue: { [unowned self] in
                    self.news = $0
                })
            .store(in: &self.cancellable)
    }
    
    func fetchItemsFromService() {
        
        service.fetchArticles(from: NewsAPI.Endpoint.newsFromSources(["cnn", "reuters", "lenta.ru"]))
            .sink(
                receiveCompletion:  { [unowned self] (completion) in
                if case let .failure(error) = completion {
                    self.error = error
                }},
                  receiveValue: { [unowned self] in
                    self.addToDB(items: $0)
            })
            .store(in: &self.cancellable)
    }
}
 
extension NewsListInteractor: NewsListInteractorProtocol {
    
    func markAsReadNewsItem(item: NewsItem) {
        var updatedItem = item
        updatedItem.isAlreadyRead = true
        database.updateRelevantFieldsFrom(item: updatedItem)
    }
}

extension NewsListInteractor {
    
    private func subscribeOnDBChanges() {
        database.observeNewsItemsChanges { [weak self] changes in
            guard let self = self else { return }
            switch changes {
            case .initial:
                self.setupScheduledFetching()

            case .update(let elements, let deletions, let insertions, let modifications):
                // TODO: make diff based updates
                self.fetchItemsFromDB()
                
            case .error(let error): self.error = error
                
            }
        }
    }
    
    // Save received data from NewsAPI
    private func addToDB(items: [NewsAPI.Article]) {
        database.create(using: items)
    }
    
    private func setupScheduledFetching() {
        if timer == nil {
            let timer = Timer.scheduledTimer(withTimeInterval: scheduledTimerInterval, repeats: true) { [weak self] (timer) in
                self?.fetchItemsFromService()
            }
            RunLoop.current.add(timer, forMode: .common)
            timer.tolerance = 0.1
            self.timer = timer
        }
    }
    
    private func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }
}
