//
//  SettingsContentView.swift
//  NewsAgregator
//
//  Created by Sergey Gorin on 25.04.2022.
//

import SwiftUI

final class SettingsViewModel {
    var timeFrequencies: [Int]          // Array of minutes
    @Published var selectedIndex: Int   // Index of selected value
    
    private var sources: [String] = []
    
    init(timeFrequencies: [Int], selectedIndex: Int) {
        self.timeFrequencies = timeFrequencies
        self.selectedIndex = selectedIndex
    }
}

protocol SettingsStoreProtocol: ObservableObject {
    
    // Should implement with @Published wrapper
    var viewModel: SettingsViewModel { get set }
}

struct SettingsContentView<Store: SettingsStoreProtocol>: View {
    
    @ObservedObject private var store: Store
    
    init(store: Store) {
        self.store = store
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker(selection: $store.viewModel.selectedIndex,
                           label: Text("Update frequency")) {
                        
                        let items = Array(store.viewModel.timeFrequencies)
                        ForEach(0 ..< items.count, id:\.self) {
                            Text("\(items[$0]) min").tag($0)
                        }
                    }
                    .font(.headline)
                }
            }.navigationBarTitle(Text("Settings"), displayMode: .inline)
        }
    }
}

struct SettingsContentView_Previews: PreviewProvider {
    
    final class SampleStore: SettingsStoreProtocol {
        var viewModel = SettingsViewModel(
            timeFrequencies: [1, 2, 5, 10, 15, 30, 60],
            selectedIndex: 2)
    }
    
    static var previews: some View {
        NavigationView {
            SettingsContentView(store: SampleStore())
        }
    }
}
