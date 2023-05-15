//
//  ExplorerGridView.swift
//  tvExplorer
//
//  Created by Alexandre Porto Alegre Fernandes on 12/05/23.
//

import SwiftUI

struct ExplorerGridView: View {
    
    @StateObject private var viewModel = ViewModel(networkService: ShowsNetworkService())
    @State var shows = [Show.sampleShow]
    
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: adaptiveColumns, spacing: 10) {
                    ForEach(viewModel.showList) { show in
                        NavigationLink(destination: ShowDetailView(show: show)){
                            ExplorerGridItemView(show: show)
                                .onAppear() {
                                    viewModel.fetchShowsContent(currentShow: show)
                                }
                        }
                    }
                }
            }
            .navigationTitle("TV Explorer")
            .environmentObject(viewModel)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .searchable(text: $viewModel.searchText, prompt: "Search show")
        .onSubmit(of: .search){
            viewModel.fetchShowsContent(currentShow: nil)
        }
        .onAppear {
            viewModel.fetchShowsContent(currentShow: nil)
        }
        .ignoresSafeArea(edges: .bottom)
        .overlay(alignment: .bottom){
            if viewModel.fetchingShows {
                ProgressView("Fetching shows")
                    .padding(10)
                    .frame(maxWidth: .infinity, maxHeight: 100)
                    .background(Gradient(stops: [
                        .init(color: Color.gray.opacity(0), location: 0),
                        .init(color: Color.gray, location: 0.7)
                        ]))
                    .foregroundColor(.white)
                    .progressViewStyle(.circular)
                    .tint(.white)
                    .ignoresSafeArea(edges: .bottom)
            }
        }
    }
}

struct ExplorerGridView_Previews: PreviewProvider {
    static var previews: some View {
        ExplorerGridView()
    }
}
