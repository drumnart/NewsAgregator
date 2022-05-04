//
//  SettingsStore.swift
//  NewsAgregator
//
//  Created by Sergey Gorin on 04.05.2022.
//

import Foundation
import Combine

protocol SettingsPresenterInput: AnyObject {
    func selectFrequency(index: Int)
}

protocol SettingsPresenterOutput: AnyObject {
    /// Sets update frequency parameters
    ///
    /// - Parameter frequencies: array of time frequencies measured in minutes
    /// - Parameter selectedFrequencyIndex: Index of selected frequency
    func set(frequencies: [Int], selectedFrequencyIndex: Int)
}

final class SettingsStore: SettingsStoreProtocol {
    
    @Published var viewModel: SettingsViewModel
    
    private var presenter: SettingsPresenterInput
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: SettingsViewModel, presenter: SettingsPresenterInput) {
        self.viewModel = viewModel
        self.presenter = presenter
        
        viewModel.$selectedIndex
            .dropFirst()
            .sink {
                presenter.selectFrequency(index: $0)
            }
            .store(in: &cancellables)
    }
}

extension SettingsStore: SettingsPresenterOutput {
    
    func set(frequencies: [Int], selectedFrequencyIndex: Int) {
        viewModel.timeFrequencies = frequencies
        viewModel.selectedIndex = selectedFrequencyIndex
    }
}
