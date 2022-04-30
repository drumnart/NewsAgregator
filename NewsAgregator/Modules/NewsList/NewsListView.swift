//
//  NewsListView.swift
//  NewsAgregator
//
//  Created by Sergey Gorin on 25.04.2022.
//

import SwiftUI

protocol NewsListPresenterProtocol {

    associatedtype Item: NewsItemViewModel
    var store: NewsListStore<Item> { get }
    
    func getDstinationView(for item: Item) -> AnyView
    func presentSettings()
}

struct NewsListView<Item, T>: View where T: NewsListPresenterProtocol, T.Item == Item {
    
    private var presenter: T
    
    @ObservedObject private var store: NewsListStore<Item>
    
    @State private var expandedCells = Set<String>()
    @State private var showSettings = false
    
    init(presenter: T) {
        self.presenter = presenter
        self.store = presenter.store
        prepare()
    }
    
    var body: some View {
        List {
            ForEach(store.newsItems) { item in
                // TODO: Create separate view for list item
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
                        
                    if expandedCells.contains(item.id) {
                        Text("\(item.newsDescription)")
                            .lineLimit(10)
                            .padding(.horizontal, 8)
                            .transition(.opacity)
                        Spacer()
                    }  else {
                        Spacer(minLength: 0)
                        Button {
                            withAnimation {
                                expandItem(id: item.id)
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
                    NavigationLink("", destination: presenter.getDstinationView(for: item)).opacity(0)
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
        .animation(presenter.store.isInitialLoad ? nil : .default,
                   value: presenter.store.newsItems)
        .sheet(isPresented: $showSettings, onDismiss: nil) {
            
        }
        .navigationBarTitle("News", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: openSettings) {
            Image(systemName: "gearshape").foregroundColor(.black)
        })
    }
    
    private func expandItem(id: String) {
        expandedCells.insert(id)
    }
    
    func openSettings() {
         showSettings = true
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
        
        let interactor = NewsListInteractor(service: NewsAPI.shared, database: Realm_NewsDB.shared)
        let router = NewsListRouter()
        let presenter = NewsListPresenter_Previews(interactor: interactor, router: router)
        NavigationView {
            NewsListView(presenter: presenter)
        }
    }
}
