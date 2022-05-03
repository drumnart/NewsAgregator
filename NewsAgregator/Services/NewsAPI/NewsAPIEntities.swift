//
//  Article.swift
//  NewsAgregator
//
//  Created by Sergey Gorin on 25.04.2022.
//

import Foundation
import CryptoKit

extension NewsAPI {
    
    struct Response: Codable {
        let status: String?
        let totalResults: Int?
        let articles: [Article]
    }
    
    struct Source: Codable, Identifiable {
        let id: String?
        let name: String?
        
        enum CodingKeys: CodingKey {
            case id, name
        }
    }
    
    struct Article: Codable {
        let source: Source
        let author: String?
        let title: String?
        let description: String?
        let url: String?
        let urlToImage: String?
        let publishedAt: Date?
        let content: String?
    }
}
