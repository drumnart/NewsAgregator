//
//  NewsImageView.swift
//  NewsAgregator
//
//  Created by Sergey Gorin on 26.04.2022.
//

import SwiftUI

struct NewsImageView: View {
    
    @ObservedObject var imageLoader: ImageLoader
    
    var body: some View {
        ZStack {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                
            } else {
                EmptyView()
            }
        }
    }
}

struct NewsImageView_Previews: PreviewProvider {
    static var previews: some View {
        NewsImageView(imageLoader: ImageLoader(url: URL(string: "https://img-cdn.tnwcdn.com/image/tnw?filter_last=1&fit=1280%2C640&url=https%3A%2F%2Fcdn0.tnwcdn.com%2Fwp-content%2Fblogs.dir%2F1%2Ffiles%2F2022%2F04%2Fmuskvader.jpg&signature=cd939b7c5dc99789d73bb52ebffdc7c3")))
    }
}
