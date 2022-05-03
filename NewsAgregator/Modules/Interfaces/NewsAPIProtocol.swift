//
//  NewsAPIProtocol.swift
//  NewsAgregator
//
//  Created by Sergey Gorin on 29.04.2022.
//

import Foundation
import Combine

protocol NewsAPIProtocol {
    
    func fetchNews(from sources: [String]) -> AnyPublisher<[NewsAPI.Article], NewsAPI.APIError>
}

extension NewsAPI: NewsAPIProtocol {
    
    func fetchNews(from sources: [String]) -> AnyPublisher<[NewsAPI.Article], NewsAPI.APIError> {
        fetchArticles(from: NewsAPI.Endpoint.newsFromSources(sources))
    }
}
