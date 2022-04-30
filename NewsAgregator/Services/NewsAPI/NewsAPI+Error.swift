//
//  NewsAPI+Error.swift
//  NewsAgregator
//
//  Created by Sergey Gorin on 26.04.2022.
//

import Foundation

extension NewsAPI {
    
    enum APIError: Error, LocalizedError {
        case urlError(URLError)
        case responseError(status: Int, message: String)
        case decodingError(DecodingError)
        case unknown
        
        var localizedDescription: String {
            switch self {
            case .urlError(let error):
                return error.localizedDescription
                
            case .responseError(let status, let message):
                let range = (message.range(of: "message\":")?.upperBound
                         ?? message.startIndex)..<message.endIndex
                return "Bad response code: \(status) - message : \(message[range])"
                
            case .decodingError(let error):
                var description = error.localizedDescription
                switch error {
                case .dataCorrupted(let context):
                    let details = context.underlyingError?.localizedDescription
                               ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
                    description = "\(context.debugDescription) - (\(details))"
                    
                case .keyNotFound(let key, let context):
                    let details = context.underlyingError?.localizedDescription
                               ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
                    description = "\(context.debugDescription) (key: \(key), \(details))"
                    
                case .typeMismatch(let type, let context), .valueNotFound(let type, let context):
                    let details = context.underlyingError?.localizedDescription
                               ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
                    description = "\(context.debugDescription) (type: \(type), \(details))"
                    
                @unknown default:
                    break
                }
                return description
           
            case .unknown:
                return "Unknown error has occured"
            }
        }
    }
}
