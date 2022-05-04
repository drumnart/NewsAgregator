//
//  APIServiceWorker.swift
//  NewsAgregator
//
//  Created by Sergey Gorin on 02.05.2022.
//

import Foundation
import Combine

protocol APIServiceWorkerProtocol {
    func fetchNews(from sources: [String], language: Language, completion: ((Result<Void, Error>) -> Void)?)
}

protocol APIServiceDelegate: AnyObject {
    func save(articles: [NewsAPI.Article]) throws
}

class APIServiceWorker: APIServiceWorkerProtocol {
    
    private var apiService: NewsAPIProtocol
    private weak var delegate: APIServiceDelegate?
    private var cancellables = Set<AnyCancellable>()
    
    init(apiService: NewsAPIProtocol, delegate: APIServiceDelegate?) {
        self.apiService = apiService
        self.delegate = delegate
    }
    
    // Fetches news from API and saves to database.
    // Callback returns failure with error in case of failed request, othervise success
    func fetchNews(from sources: [String], language: Language, completion: ((Result<Void, Error>) -> Void)?) {
        let outerCompletion = completion
        apiService.fetchNews(from: sources, language: language)
            .sink(
                receiveCompletion:  { (completion) in
                    switch completion {
                    case .failure(let error): outerCompletion?(.failure(error))
                    case .finished: outerCompletion?(.success(()))
                    }
                },
                receiveValue: { [unowned self] in
                    do {
                        try self.delegate?.save(articles: $0)
                    } catch {
                        outerCompletion?(.failure(error))
                    }
                }
            )
            .store(in: &self.cancellables)
    }
}
