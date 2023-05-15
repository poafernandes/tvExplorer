//
//  ShowDetailView.swift
//  tvExplorer
//
//  Created by Alexandre Porto Alegre Fernandes on 12/05/23.
//

import SwiftUI
import SafariServices


struct ShowDetailView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    var show: Show
        
    var body: some View {
        AdaptableStackView {
            VStack {
                Image(uiImage: show.image)
                    .resizable()
                    .border(.white, width: 5)
                    .aspectRatio(contentMode: .fit)
                    .overlay(alignment: .topLeading) {
                        Text(String(show.rating ?? 0))
                            .padding(6)
                            .background(LinearGradient(colors: [.orange, .yellow], startPoint: .top, endPoint: .center))
                            .padding(10)
                            .fontWeight(.heavy)
                    }
                Text(show.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Group{
                    Text(String(show.startYear))
                    + Text(" - ")
                    + Text(String(show.endYear ?? 0))
                }
                .font(.subheadline)
                .foregroundColor(.white)
                
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(Color(uiColor: .systemGray))
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Known as: ")
                        .foregroundColor(.primary)
                        .font(.subheadline)
                        .fontWeight(.bold)
                    + Text(show.aka?.joined(separator: ", ") ?? "N/A")
                    Text("Genres: ")
                        .foregroundColor(.primary)
                        .font(.subheadline)
                        .fontWeight(.bold)
                    + Text(show.genres.joined(separator: ", "))
                    
                    Text("About: ")
                        .foregroundColor(.primary)
                        .font(.subheadline)
                        .fontWeight(.bold)
                    + Text(show.summary)
                }
                .padding(20)
                Button {
                    let safariVC = SFSafariViewController(url: URL(string: show.externalUrl)!)

                    UIApplication.shared.firstKeyWindow?.rootViewController?.present(safariVC, animated: true)
                } label: {
                    Image(systemName: "link")
                    Text("More on TVMaze")
                }
                .padding(20)
            }
        }
    }
}

struct ShowDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ShowDetailView(show: Show.sampleShow)
            .environmentObject(ViewModel(networkService: ShowsNetworkService()))
    }
}
