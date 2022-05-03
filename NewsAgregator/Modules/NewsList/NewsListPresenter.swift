//
//  NewsListPresenter.swift
//  NewsAgregator
//
//  Created by Sergey Gorin on 25.04.2022.
//

import Foundation
import Combine
import SwiftUI

protocol NewsListInteractorInput {
    
    func markAsReadNewsItem(id: String)
}

protocol NewsListInteractorOutput: AnyObject {
    
    func present(items: [NewsItem])
    func present(error: Error)
}

protocol NewsListRouterProtocol: AnyObject {
    func presentDetailsScreen(item: NewsItemViewModel, onAppear: (() -> Void)?) -> AnyView
}

final class NewsListPresenter {
    
    private var interactor: NewsListInteractorInput
    private var router: NewsListRouterProtocol
    
    private weak var output: NewListPresenterOutput?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(interactor: NewsListInteractorInput, router: NewsListRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func setup(output: NewListPresenterOutput?) {
        self.output = output
    }
}

extension NewsListPresenter: NewsListPresenterInput {
    
    func getDestinationView(for item: NewsItemViewModel) -> AnyView {
        return router.presentDetailsScreen(item: item, onAppear: { [weak self] in
            self?.interactor.markAsReadNewsItem(id: item.id)
        })
    }
    
    func selectPresentSettings() {
        
    }
}

extension NewsListPresenter: NewsListInteractorOutput {
    
    func present(items: [NewsItem]) {
        output?.add(items: items.map { NewsItemViewModel(newsItem: $0) })
    }
    
    func present(error: Error) {
        output?.handle(error: .any(error))
    }
}
