//
//  NewsAPI.swift
//  NewsAgregator
//
//  Created by Sergey Gorin on 26.04.2022.
//

import Foundation
import Combine

final class NewsAPI {
    
    static let apiKey = "51d808e82ce7446a9cd31b96be6f9c3d"
    static let baseURLString = "https://newsapi.org/v2/"
    
    static let shared = NewsAPI()
    init() {}
    
    let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()
    
    private var cancellable = Set<AnyCancellable>()
}

extension NewsAPI: NewsAPIProtocol {
    
    // Fetch Articles from a given endpoint
    func fetchArticles(from endpoint: Endpoint) -> AnyPublisher<[Article], APIError> {
        Future<[Article], APIError> { [unowned self] promise in
 
            guard let urlRequest = endpoint.urlRequest, let _ = urlRequest.url else {
                return promise(.failure(.urlError(URLError(.unsupportedURL))))
            }
            self.fetch(urlRequest)
                .tryMap { (result: Response) -> [Article] in
                      result.articles
                }
                .sink(
                    receiveCompletion: { (completion) in
                        if case let .failure(error) = completion {
                            let refinedError: APIError
                            switch error {
                            case let urlError as URLError:
                                refinedError = .urlError(urlError)
                                
                            case let decodingError as DecodingError:
                                refinedError = .decodingError(decodingError)
                                
                            case let apiError as APIError:
                                refinedError = apiError
                                
                            default:
                                refinedError = .unknown
                            }
                            
                            #if DEBUG
                            print("NewsAPI: \(refinedError.localizedDescription)")
                            #endif
                            
                            promise(.failure(refinedError))
                        }
                    },
                    receiveValue: { promise(.success($0)) }
                )
             .store(in: &self.cancellable)
        }
        .eraseToAnyPublisher()
    }
    
    private func fetch<T: Decodable>(_ urlRequest: URLRequest) -> AnyPublisher<T, Error> {
        URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                        200...299 ~= httpResponse.statusCode else {
                    
                    let status = (response as? HTTPURLResponse)?.statusCode ?? 500
                    let message = String(data: data, encoding: .utf8) ?? ""
                    let error = APIError.responseError(status: status, message: message)
                    
                    #if DEBUG
                    print("NewsAPI: \(error.localizedDescription)")
                    #endif
                    
                    throw error
                }
                return data
            }
            .decode(type: T.self, decoder: jsonDecoder)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

extension NewsAPI {
    
    enum SortBy: String {
        // articles more closely related to search query
        case relevancy
        
        //  articles from popular sources and publishers come first
        case popularity
        
        // newest articles come first
        case publishedAt
    }
    
    enum Endpoint {
        // To search through millions of articles
        // sources - array sources's ids
        // sortBy - the order to sort articles in. Default value is '.publishedAt'
        // TODO: Add more params
        case newsFromSources(_ sources: [String], sortBy: SortBy = .publishedAt)
        
        // To receive top and breaking headlines
        // TODO: Add params
        case topHeadLines
        
        var path: String {
            switch self {
            case .newsFromSources: return "everything"
            case .topHeadLines: return "top-headlines"
            }
        }
        
        var urlRequest: URLRequest? {
            guard let url = URL(string: NewsAPI.baseURLString)?.appendingPathComponent(path) else {
                return nil
            }
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            guard var urlComponents = components else {
                return nil
            }
            switch self {
            case .newsFromSources(let sources, let sortBy):
                urlComponents.queryItems = [URLQueryItem(name: "sources", value: sources.joined(separator: ",")),
                                            URLQueryItem(name: "sortBy", value: sortBy.rawValue)]
            case .topHeadLines:
                urlComponents.queryItems = [URLQueryItem(name: "country", value: region)]
            }
            
            guard let url = urlComponents.url else { return nil }
            var urlRequest = URLRequest(url: url)
            urlRequest.setValue(NewsAPI.apiKey, forHTTPHeaderField: "X-Api-Key")
            
            return urlRequest
        }
        
        var region: String {
            return  Locale.current.regionCode?.lowercased() ?? "us"
        }
    }
}
