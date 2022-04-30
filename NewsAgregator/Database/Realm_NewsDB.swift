//
//  RealmDB.swift
//  NewsAgregator
//
//  Created by Sergey Gorin on 29.04.2022.
//

import Foundation
import Combine
import RealmSwift

class Realm_NewsDB {
    static let shared = Realm_NewsDB()
    
    var notificationToken: NotificationToken?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {}
    
    deinit {
        notificationToken?.invalidate() 
    }
}

extension Realm_NewsDB: NewsDBProtocol {

    func observeNewsItemsChanges(_ closure: @escaping (Change) -> Void) {
        if let realm = try? Realm() {
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
    }
    
    func fetch() -> AnyPublisher<[RealmNewsItem], Error> {
        Future<[RealmNewsItem], Error> { [unowned self] promise in
            
            do {
                let realm = try Realm()
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
                        receiveValue: { item in promise(.success(item)) }
                    )
                    .store(in: &self.cancellables)
                    
            } catch {
                #if DEBUG
                print(error.localizedDescription)
                #endif
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getMostRecentPublishDate() -> Date? {
        do {
            let realm = try Realm()
            return realm.objects(RealmNewsItem.self).max(of: \.publishedAt)
        } catch {
            handleCatchedError(error)
            return nil
        }
    }
    
    func updateRelevantFieldsFrom(item: NewsItem) {
        do {
            let realm = try Realm()
            try realm.write {
                if let realmItem = realm.objects(RealmNewsItem.self).where ({
                    $0.id == item.id
                }).first {
                    realmItem.update(from: item)
                }
            }
        } catch { handleCatchedError(error) }
    }
    
    func create(using items: [NewsAPI.Article]) {
        update(using: items)
    }
    
    func update(using items: [NewsAPI.Article]) {
        let dbItems = items.map {
            RealmNewsItem(article: $0)
        }
        
        do {
            let realm = try Realm()
            
            let filteredItems = dbItems.drop { item in
                realm.objects(RealmNewsItem.self).contains { $0.id == item.id }
            }
            
            try realm.write {
                realm.add(filteredItems, update: .modified)
            }
        } catch { handleCatchedError(error) }
    }
    
    private func handleCatchedError(_ error: Error) {
        // TODO: Add processing of this case
        #if DEBUG
        print(error.localizedDescription)
        #endif
    }
}
