//
//  NewsAPIProtocol.swift
//  NewsAgregator
//
//  Created by Sergey Gorin on 29.04.2022.
//

import Foundation
import Combine

protocol NewsAPIProtocol {
    
    func fetchArticles(from endpoint: NewsAPI.Endpoint) -> AnyPublisher<[NewsAPI.Article], NewsAPI.APIError>
}
