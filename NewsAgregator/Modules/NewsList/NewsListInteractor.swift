//
//  NewsListInteractor.swift
//  NewsAgregator
//
//  Created by Sergey Gorin on 25.04.2022.
//

import Foundation
import Combine

class NewsListInteractor {
    
    @Published var sources: [String] = [
        "lenta", "rbc", "google-news-ru",
        "abc-news", "al-jazeera-english", "associated-press",
        "bloomberg", "business-insider", "cnn",
        "financial-post", "fortune", "fox-news", "fox-sports",
        "independent", "mtv-news", "newsweek", "new-york-magazine",
        "reuters", "techcrunch", "the-washington-post"
    ]
    @Published var selectedSources = Set(["lenta", "rbc", "google-news-ru"])
    @Published var language: Language = .ru
    
    private var preferences = Preferences.self
    
    typealias NewsDatabaseService = NewsDBProtocol & APIServiceDelegate
    
    private var apiServiceWorker: APIServiceWorkerProtocol
    private var databaseService: NewsDatabaseService
    
    private weak var output: NewsListInteractorOutput?
    
    private var cancellable: Set<AnyCancellable> = []
    
    private var timer: Timer?
    
    private let minimumInterval: TimeInterval = 15
    
    // Fetching data frequency
    private var scheduledTimerInterval: TimeInterval = 20 {
        didSet {
            cancelTimer()
            preferences.selectedFrequency = scheduledTimerInterval
            setupScheduledFetching(with: scheduledTimerInterval)
        }
    }
    
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
        apiServiceWorker.fetchNews(from: Array(selectedSources), language: language, completion: { result in
            if case let .failure(error) = result {
                self.output?.present(error: error)
            }
        })
    }
}
 
extension NewsListInteractor: NewsListInteractorInput {
    
    func getSettings() -> Settings {
        return Settings(
            timeFrequencies: preferences.timeFrequencies,
            selectedFrequencyIndex: preferences.timeFrequencies.firstIndex(of: preferences.selectedFrequency) ?? 0
        )
    }
    
    func applyFilters() {
        
    }
    
    
    func markAsReadNewsItem(id: String) {
        try? databaseService.setIsAlreadyRead(for: id, value: true)
    }
}

extension NewsListInteractor: SettingsInteractorInput {
    
    func selectFrequency(index: Int) {
        guard index >= 0 && index < preferences.timeFrequencies.count else {
            return
        }
        
        let interval = preferences.timeFrequencies[index]
        scheduledTimerInterval = interval
    }
}

extension NewsListInteractor {
    
    private func subscribeOnDBChanges() {
        databaseService.observeNewsItemsChanges { [weak self] changes in
            guard let self = self else { return }
            switch changes {
            case .initial:
                self.setupScheduledFetching(with: Double(self.preferences.selectedFrequency))

            case .update(let elements, let deletions, let insertions, let modifications):
                // TODO: make diff based updates
                self.fetchItemsFromDB()
                
            case .error(let error):
                self.output?.present(error: error)
            }
        }
    }
    
    private func setupScheduledFetching(with interval: TimeInterval) {
        guard interval >= minimumInterval else { return }
        
        if timer == nil {
            let timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] (timer) in
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
