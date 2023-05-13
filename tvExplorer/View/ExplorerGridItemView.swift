//
//  ExplorerGridItemView.swift
//  tvExplorer
//
//  Created by Alexandre Porto Alegre Fernandes on 12/05/23.
//

import SwiftUI

struct ExplorerGridItemView: View {

    @Binding var show: Show
    
    var body: some View {
        
        ZStack{
            Image(show.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
            VStack(spacing: 10) {
                Spacer()
                Text(show.title)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(show.ongoing ? "Ongoing" : "Ended")
                    .font(.subheadline)
                    .foregroundColor(.red)
                .frame(maxWidth: .infinity)

            }
            .padding(20)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.4), Color.black.opacity(0.7)]), startPoint: .top, endPoint: .bottom)
            )
        }
        .cornerRadius(20)
        .padding(10)
    }
}

struct ExplorerGridItemView_Previews: PreviewProvider {
    static var previews: some View {
        ExplorerGridItemView(show: .constant(exampleShow))
    }
}
