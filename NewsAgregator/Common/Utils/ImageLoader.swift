//
//  ImageLoader.swift
//  NewsAgregator
//
//  Created by Sergey Gorin on 26.04.2022.
//

import UIKit
import Combine

final class ImageLoader: ObservableObject {
    
    private var cancellable = Set<AnyCancellable>()
    
//    @Published var url: URL?
    
    private var cache = ImagesCache.shared
    
    @Published var image: UIImage?
    @Published var error: Error?
    
    init(url: URL?) {
        fetchImage(for: url)
            .sink(
                receiveCompletion:  {[unowned self] (completion) in
                    if case .failure(let error) = completion {
                        self.error = error
                    }},
                receiveValue: { [unowned self] in
                    self.image = $0
                }
            )
            .store(in: &self.cancellable)
    }
    
    private func fetchImage(for url: URL?) -> AnyPublisher<UIImage?, Error>{
        Future<UIImage?, Error> { [unowned self] promise in
            guard let url = url else {
                return promise(.failure(URLError(.unsupportedURL)))
            }
            if let image = cache.imageFor(key: url.absoluteString) {
                promise(.success(image))
            } else {
                URLSession.shared.dataTaskPublisher(for: url)
                    .tryMap { (data, response) -> Data in
                        guard let httpResponse = response as? HTTPURLResponse,
                            200...299 ~= httpResponse.statusCode else {
                                throw URLError(.unsupportedURL)
                        }
                        return data
                    }
                    .map { UIImage(data: $0) }
                    .receive(on: RunLoop.main)
                    .sink(
                        receiveCompletion: { (completion) in
                            if case let .failure(error) = completion {
                                promise(.failure(error))
                            }
                        },
                        receiveValue: {
                            if let image = $0 {
                                self.cache.setImage(image, for: url.absoluteString)
                            }
                            promise(.success($0))
                        }
                    )
                    .store(in: &self.cancellable)
            }
        }.eraseToAnyPublisher()
    }
}

final class ImagesCache {
    
    static let shared = ImagesCache()
    
    private var cache: NSCache<NSString, UIImage> = NSCache()
    
    func imageFor(key: String) -> UIImage? {
        let nsKey = NSString(string: key)
        return cache.object(forKey: nsKey)
    }
    
    func setImage(_ image: UIImage, for key: String) {
        let nsKey = NSString(string: key)
        cache.setObject(image, forKey: nsKey)
    }
}

extension ImageLoader {
    
    
}
