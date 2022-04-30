//
//  NewsDetailsView.swift
//  NewsAgregator
//
//  Created by Sergey Gorin on 28.04.2022.
//

import SwiftUI

struct NewsDetailsView: View {
    
    @State var item: NewsItem
    
    private var onAppearClossure: (() -> Void)?
    
    init(item: NewsItem, onAppear: (() -> Void)? = nil) {
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
        let newsItem = RealmNewsItem(article: Samples.sampleAPIItem5)
        NewsDetailsView(item: NewsItem(realmNewsItem: newsItem))
    }
}
