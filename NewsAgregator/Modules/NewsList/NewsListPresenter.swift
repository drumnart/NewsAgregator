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
    func getSettings() -> Settings
    func applyFilters()
}

protocol NewsListInteractorOutput: AnyObject {
    
    func present(items: [NewsItem])
    func present(error: Error)
}

protocol NewsListRouterProtocol: AnyObject {
    func presentDetailsScreen(item: NewsItemViewModel, onAppear: (() -> Void)?) -> AnyView
    func presentSettings(viewModel: SettingsViewModel, interactor: SettingsInteractorInput) -> AnyView
}

final class NewsListPresenter {
    
    typealias InteractorInput = NewsListInteractorInput & SettingsInteractorInput
    
    private var interactor: InteractorInput
    private var router: NewsListRouterProtocol
    
    private weak var output: NewListPresenterOutput?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(interactor: InteractorInput, router: NewsListRouterProtocol) {
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
    
    func getSettingsView() -> AnyView {
        let settings = interactor.getSettings()
        let viewModel = SettingsViewModel(
            timeFrequencies: settings.timeFrequencies.map { Int($0) / 60 },
            selectedIndex: settings.selectedFrequencyIndex
        )
        return router.presentSettings(viewModel: viewModel, interactor: interactor)
    }
    
    func selectPresentSettings() {
    }
    
    func applyFilters() {
        interactor.applyFilters()
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
