//
//  RealmDB.swift
//  NewsAgregator
//
//  Created by Sergey Gorin on 29.04.2022.
//

import Foundation
import Combine
import RealmSwift

final class Realm_NewsDB {
    
    static let shared = Realm_NewsDB()
    
    static var config: Realm.Configuration  = .defaultConfiguration
    
    private var realm: Realm {
        do {
            // Realm Instance with default Configuration.
            // Should use custom config to support migration through schema upgrate.
            return try Realm(configuration: Realm_NewsDB.config)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    private var notificationToken: NotificationToken?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {}
    
    deinit {
        notificationToken?.invalidate() 
    }
    
    // Point to write to Realm
    func write(_ closure: @escaping ((Realm) -> Void)) throws {
        try realm.write {
            closure(realm)
        }
    }
    
    // Adds a single object
    func add(_ object: Object, update: Realm.UpdatePolicy = .all) throws {
        try write { realm in
            realm.add(object, update: update)
        }
    }
        
    // Adds a list of objects
    func add<S: Sequence>(_ objects: S, update: Realm.UpdatePolicy = .all) throws where S.Iterator.Element: Object {
        try write { realm in
            realm.add(objects, update: update)
        }
    }
}

// MARK: - News
extension Realm_NewsDB: NewsDBProtocol {
    
    func observeNewsItemsChanges(_ closure: @escaping (Change) -> Void) {
        
        let results = realm.objects(RealmNewsItem.self).sorted(by: \.publishedAt, ascending: false)
        
        notificationToken = results.observe { changes in
            switch changes {
            case .initial: closure(.initial)
            case .update(let elements, let deletions, let insertions, let modifications):
                var items: [RealmNewsItem] = []
                elements.forEach { items.append($0) }
                closure(.update(items: items, deletions: deletions, insertions: insertions, modifications: modifications))
                
            case .error(let error):
                closure(.error(error))
                print("An error occurred while opening the Realm file")
            }
        }
    }
    
    // Fetch
    func fetchNews() -> AnyPublisher<[NewsItem], Error> {
        Future<[NewsItem], Error> { [unowned self] promise in
            
            let news = realm.objects(RealmNewsItem.self).sorted(by: \.publishedAt, ascending: false)
            return news.collectionPublisher
                .freeze()
                .map { item in
                    item.map { $0 }
                }
                .receive(on: RunLoop.main)
                .sink(
                    receiveCompletion: { completion in
                        if case let .failure(error) = completion {
                            promise(.failure(error))
                        }
                    },
                    receiveValue: {
                        let items = Array($0.map { return NewsItem(realmNewsItem: $0) })
                        promise(.success(items))
                    }
                )
                .store(in: &self.cancellables)
        }
        .eraseToAnyPublisher()
    }
    
    func setIsAlreadyRead(for id: String, value: Bool) throws {
        try write { realm in
            if let realmItem = realm.objects(RealmNewsItem.self).where ({
                $0.id == id
            }).first {
                realmItem.isAlreadyRead = value
            }
        }
    }
    
    func getMostRecentPublishDate() -> Date? {
        return realm.objects(RealmNewsItem.self).max(of: \.publishedAt)
    }
}

extension Realm_NewsDB: APIServiceDelegate {
    
    func save(articles: [NewsAPI.Article]) throws {
        let dbItems = articles.map { RealmNewsItem(article: $0) }
        try create(realmItems: dbItems)
    }
    
    func create(realmItems: [RealmNewsItem]) throws {
        let realmInstance = realm
        let filteredItems = realmItems.drop { item in
            realmInstance.objects(RealmNewsItem.self).contains { $0.id == item.id }
        }
        try update(realmItems: Array(filteredItems))
    }
    
    func update(realmItems: [RealmNewsItem]) throws {
        try add(realmItems, update: .modified)
    }
}
