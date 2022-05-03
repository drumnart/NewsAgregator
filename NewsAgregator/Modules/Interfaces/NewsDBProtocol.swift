//
//  NewsDBProtocol.swift
//  NewsAgregator
//
//  Created by Sergey Gorin on 29.04.2022.
//

import Foundation
import Combine

enum Change {
    // The initial run of query has completed
    case initial
    
    // Indices of changed objects in ascending order
    case update(items: [RealmNewsItem] = [], deletions: [Int], insertions: [Int], modifications: [Int])

    // In case of error
    case error(Error)
}

protocol NewsDBProtocol {
    
    func setIsAlreadyRead(for id: String, value: Bool) throws
    
    func fetchNews() -> AnyPublisher<[NewsItem], Error>
    
    func observeNewsItemsChanges(_ closure: @escaping (Change) -> Void)
    
    func getMostRecentPublishDate() -> Date?
}
