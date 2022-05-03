//
//  NewsListRouter.swift
//  NewsAgregator
//
//  Created by Sergey Gorin on 25.04.2022.
//

import Foundation
import SwiftUI

class NewsListRouter: NewsListRouterProtocol {
    
    func presentDetailsScreen(item: NewsItemViewModel, onAppear: (() -> Void)?) -> AnyView {
        return AnyView(NewsDetailsView(item: item, onAppear: onAppear))
    }
}
