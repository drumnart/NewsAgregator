//
//  MainContentView.swift
//  NewsAgregator
//
//  Created by Sergey Gorin on 27.04.2022.
//

import SwiftUI

struct MainContentView: View {
    var body: some View {
      NavigationView {
          NewsListModuleBuilder.build()
      }
    }
}

struct MainContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainContentView()
    }
}
