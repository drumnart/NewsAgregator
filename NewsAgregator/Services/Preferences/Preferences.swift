//
//  Preferences.swift
//  NewsAgregator
//
//  Created by Sergey Gorin on 04.05.2022.
//

import Foundation

public struct Preferences {
    
    /// Update frequency in seconds
    @UserDefaultsWrapper("time_frequencies", defaultValue: [60, 120, 300, 600, 900, 1800, 3600])
    public static var timeFrequencies: [TimeInterval]
    
    /// Selected frequency index
    @UserDefaultsWrapper("selected_frequency", defaultValue: 120)
    public static var selectedFrequency: TimeInterval
}
