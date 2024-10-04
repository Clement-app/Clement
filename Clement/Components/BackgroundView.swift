//
//  BackgroundView.swift
//  Clement
//
//  Created by Alex Catchpole on 01/10/2024.
//

import SwiftUI

struct BackgroundView<Content: View>: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @ViewBuilder var content: () -> Content
    
    var color: Color = Color.green5

    var body: some View {
        ZStack {
            color.ignoresSafeArea()
            content()
        }
    }
}
#Preview {
    BackgroundView {
        Text("Hello")
    }
}
