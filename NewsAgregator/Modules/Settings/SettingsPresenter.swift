//
//  SettingsPresenter.swift
//  NewsAgregator
//
//  Created by Sergey Gorin on 04.05.2022.
//

import Foundation

protocol SettingsInteractorInput: AnyObject {
    /// Index if selected frequency
    func selectFrequency(index: Int)
}

protocol SettingsInteractorOutput: AnyObject {
    /// Sets update frequncies in seconds and index of selected frequency
    func set(frequencies: [TimeInterval], selectedFrequencyIndex: Int)
}

final class SettingsPresenter {
    
    private var interactor: SettingsInteractorInput
    private weak var output: SettingsPresenterOutput?
    
    init(interactor: SettingsInteractorInput) {
        self.interactor = interactor
    }
    
    func setup(output: SettingsPresenterOutput?) {
        self.output = output
    }
}

extension SettingsPresenter: SettingsPresenterInput {
    
    func selectFrequency(index: Int) {
        interactor.selectFrequency(index: index)
    }
}

extension SettingsPresenter: SettingsInteractorOutput {
    
    func set(frequencies: [TimeInterval], selectedFrequencyIndex: Int) {
        let minutes = frequencies.map { Int($0 / 60) }
        output?.set(frequencies: minutes, selectedFrequencyIndex: selectedFrequencyIndex)
    }
}
