//
//  NewsDetailsView.swift
//  NewsAgregator
//
//  Created by Sergey Gorin on 28.04.2022.
//

import SwiftUI

struct NewsDetailsView: View {
    
    @State var item: NewsItemViewModel
    
    private var onAppearClossure: (() -> Void)?
    
    init(item: NewsItemViewModel, onAppear: (() -> Void)? = nil) {
        self.item = item
        self.onAppearClossure = onAppear
    }
    
    var body: some View {
        VStack {
            Text(item.newsDescription)
                .padding()
                .onAppear { onAppearClossure?() }
            Spacer()
        }
    }
}

struct NewsDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let realmNewsItem = RealmNewsItem(article: Samples.sampleAPIItem5)
        let newsItem = NewsItem(realmNewsItem: realmNewsItem)
        NewsDetailsView(item: NewsItemViewModel(newsItem: newsItem))
    }
}
