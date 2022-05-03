//
//  NewsListInteractor.swift
//  NewsAgregator
//
//  Created by Sergey Gorin on 25.04.2022.
//

import Foundation
import Combine

class NewsListInteractor {
    
    typealias NewsDatabaseService = NewsDBProtocol & APIServiceDelegate
    
    private var apiServiceWorker: APIServiceWorkerProtocol
    private var databaseService: NewsDatabaseService
    
    private weak var output: NewsListInteractorOutput?
    
    private var cancellable: Set<AnyCancellable> = []
    
    private var timer: Timer?
    
    // Fetching data frequency
    // TODO: Move to Settings
    private var scheduledTimerInterval: TimeInterval = 20
    
    init(apiServiceWorker: APIServiceWorkerProtocol, databaseService: NewsDatabaseService) {
        self.apiServiceWorker = apiServiceWorker
        self.databaseService = databaseService
        
        subscribeOnDBChanges()
        loadData()
    }
    
    deinit {
        cancelTimer()
    }
    
    func setup(output: NewsListInteractorOutput?) {
        self.output = output
    }
    
    func loadData() {
        fetchItemsFromDB()
        fetchItemsFromRemoteService()
    }
    
    // Fetches news from database
    func fetchItemsFromDB() {
        databaseService.fetchNews()
            .sink(
                receiveCompletion: { [weak self] (completion) in
                    if case let .failure(error) = completion {
                        self?.output?.present(error: error)
                    }},
                receiveValue: { [weak self] in
                    self?.output?.present(items: $0)
                })
            .store(in: &self.cancellable)
    }
    
    // Fetches news from API and saves to database.
    // Callback returns failure with error in case of failed request, othervise success
    func fetchItemsFromRemoteService() {
        apiServiceWorker.fetchNews(from: ["cnn", "reuters", "lenta.ru"], completion: { result in
            if case let .failure(error) = result {
                self.output?.present(error: error)
            }
        })
    }
}
 
extension NewsListInteractor: NewsListInteractorInput {
    
    func markAsReadNewsItem(id: String) {
        try? databaseService.setIsAlreadyRead(for: id, value: true)
    }
}

extension NewsListInteractor {
    
    private func subscribeOnDBChanges() {
        databaseService.observeNewsItemsChanges { [weak self] changes in
            guard let self = self else { return }
            switch changes {
            case .initial:
                self.setupScheduledFetching()

            case .update(let elements, let deletions, let insertions, let modifications):
                // TODO: make diff based updates
                self.fetchItemsFromDB()
                
            case .error(let error):
                self.output?.present(error: error)
            }
        }
    }
    
    private func setupScheduledFetching() {
        if timer == nil {
            let timer = Timer.scheduledTimer(withTimeInterval: scheduledTimerInterval, repeats: true) { [weak self] (timer) in
                self?.fetchItemsFromRemoteService()
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
    
    private func handleCatchedError(_ error: Error) {
        #if DEBUG
        print(error.localizedDescription)
        #endif
    }
}
