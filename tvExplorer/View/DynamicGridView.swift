//
//  DynamicGridView.swift
//  tvExplorer
//
//  Created by Alexandre Porto Alegre Fernandes on 12/05/23.
//

import SwiftUI

struct AdaptableStackView<Children: View>: View {
    @ViewBuilder var children: () -> Children
    
    var body: some View {
        GeometryReader { proxy in
            Group {
                if proxy.size.width > proxy.size.height {
                    HStack(content: children)
                } else {
                    VStack(content: children)
                }
            }
        }
    }
}
