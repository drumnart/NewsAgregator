//
//  NewsListStore.swift
//  NewsAgregator
//
//  Created by Sergey Gorin on 29.04.2022.
//

import Foundation
import SwiftUI

protocol NewsItemViewModel: Identifiable, Equatable {
    var id: String { get }
    var author: String { get } 
    var sourceName: String { get }
    var title: String { get }
    var newsDescription: String { get }
    var url: String { get }
    var urlToImage: String { get }
    var publishedAt: String { get }
     
    var isAlreadyRead: Bool { get set }
}

class NewsListStore<Item>: ObservableObject where Item: NewsItemViewModel {
    @Published var newsItems: [Item] = [] {
        didSet {
            isInitialLoad = oldValue.count == 0
        }
    }
    @Published var error: Error? = nil
    
    private(set) var isInitialLoad = true
}
