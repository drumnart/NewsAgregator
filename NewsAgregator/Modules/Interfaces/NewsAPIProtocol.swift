//
//  NewsAPIProtocol.swift
//  NewsAgregator
//
//  Created by Sergey Gorin on 29.04.2022.
//

import Foundation
import Combine

protocol NewsAPIProtocol {
    
    func fetchNews(from sources: [String], language: Language) -> AnyPublisher<[NewsAPI.Article], NewsAPI.APIError>
    func fetchSources(for language: Language?) -> AnyPublisher<[NewsAPI.Source], NewsAPI.APIError>
}

extension NewsAPI: NewsAPIProtocol {
    
    func fetchNews(from sources: [String], language: Language) -> AnyPublisher<[NewsAPI.Article], NewsAPI.APIError> {
        fetchArticles(from: NewsAPI.Endpoint.newsFromSources(sources, language: language, sortBy: .publishedAt))
    }
}
