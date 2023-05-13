//
//  ExplorerGridView.swift
//  tvExplorer
//
//  Created by Alexandre Porto Alegre Fernandes on 12/05/23.
//

import SwiftUI

struct ExplorerGridView: View {
    
    @State var shows = [exampleShow]
    
    @State private var searchText = ""
    
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: adaptiveColumns, spacing: 10) {
                    ForEach($shows) { show in
                        NavigationLink(destination: ShowDetailView(show: show)){
                            ExplorerGridItemView(show: show)
                        }
                    }
                }
            }
            .navigationTitle("TV Explorer")
        }
        .searchable(text: $searchText, prompt: "Search show")
    }
}

struct ExplorerGridView_Previews: PreviewProvider {
    static var previews: some View {
        ExplorerGridView()
    }
}
