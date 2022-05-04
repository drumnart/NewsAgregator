//
//  NewsListView.swift
//  NewsAgregator
//
//  Created by Sergey Gorin on 25.04.2022.
//

import SwiftUI

struct NewsListView: View {
    
    @ObservedObject private var store: NewsListStore
    
    init(store: NewsListStore) {
        self.store = store
        prepare()
    }
    
    var body: some View {
        List {
            ForEach(store.viewModel.items) { item in
                
                // TODO: Create separate view for list item and different states handling
                
                let vs = VStack {
                    Spacer()
                    Text("\(item.title)")
                        .font(.title)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .animation(nil)

                    Spacer(minLength: 8)
                    
                    HStack(alignment: .center) {
                        VStack(spacing: 4) {
                            Text(item.sourceName)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(Color.gray)
                                .padding(.horizontal)
                                .animation(nil)
                            
                            Text(item.publishedAt)
                                .foregroundColor(Color.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.system(size: 14))
                                .padding(.horizontal)
                                .animation(nil)
                        }
                        if item.isAlreadyRead {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding(.trailing, 12)
                                .foregroundColor(.gray)
                                .animation(nil)
                        }
                    }
                    
                    NewsImageView(
                        imageLoader: ImageLoader(url: URL(string: item.urlToImage))
                    ).animation(nil)
                        
                    if store.expandedCells.contains(item.id) {
                        Text("\(item.newsDescription)")
                            .lineLimit(10)
                            .padding(.horizontal, 8)
                            .transition(.opacity)
                        Spacer()
                    }  else {
                        Spacer(minLength: 0)
                        Button {
                            withAnimation {
                                store.dispatch(action: .expandItem(id: item.id))
                            }
                        } label: {
                            Image(systemName: "chevron.down")
                                .foregroundColor(.black)
                                .frame(minWidth: 300, minHeight: 40,  maxHeight: 40)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .frame(maxWidth: .infinity, minHeight: 40,  maxHeight: 40)
                    }
                }
                .listRowInsets(.init(top: 0, leading: 0, bottom: 10, trailing: 0))
                .background(
                    // Place NavigationLink in the background modifier as a workaround
                    // to hide unnecessary visual elements such as ">", etc.
                    NavigationLink("", destination: store.destinationView(for: item))
                        .opacity(0)
                )
                
                if #available(iOS 15, *) {
                    vs.listRowSeparator(.hidden)
                } else {
                    vs
                }
            }
            .listRowInsets(.init(top: 0, leading: 0, bottom: 10, trailing: 0))
            .background(Color.white)
            .listRowBackground(Color(.systemGroupedBackground))
        }
        .animation(store.viewModel.isInitialLoad ? nil : .default,
                   value: store.viewModel.items)
        .sheet(isPresented: $store.isSettingsViewVisible, onDismiss: {
            store.dispatch(action: .dismissSettings)
        }) {
            store.settingsView()
        }
        .navigationBarTitle("News", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: openSettings) {
            Image(systemName: "gearshape").foregroundColor(.black)
        })
    }
    
    func openSettings() {
        store.dispatch(action: .selectSettings)
    }
    
    private func prepare() {
        
        // Remove separators
        if #available(iOS 14.0, *) {
        } else {
            UITableView.appearance().tableFooterView = UIView()
        }
        UITableView.appearance().separatorStyle = .none
    }
}

struct NewsListView_Previews: PreviewProvider {
    static var previews: some View {
        
        let database = Realm_NewsDB.shared
        let serviceWorker = APIServiceWorker(apiService: NewsAPI.shared, delegate: database)
        let interactor = NewsListInteractor(apiServiceWorker: serviceWorker, databaseService: database)
        let router = NewsListRouter()
        let presenter = NewsListPresenter(interactor: interactor, router: router)
        let store = NewsListStore(presenter: presenter)
        presenter.setup(output: store)
        interactor.setup(output: presenter)
        
        let dbItem = RealmNewsItem(article: Samples.sampleAPIItem5)
        let item = NewsItem(realmNewsItem: dbItem)
        let itemViewModel = NewsItemViewModel(newsItem: item)
        
        store.add(items: [itemViewModel])
        
        return NavigationView {
            NewsListView(store: store)
        }
    }
}
