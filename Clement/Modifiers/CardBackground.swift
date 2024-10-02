//
//  Card.swift
//  Clement
//
//  Created by Alex Catchpole on 01/10/2024.
//

import SwiftUI

// view modifier
struct CardBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.accentColor)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.2), radius: 2)
    }
}

extension View {
    func cardBackground() -> some View {
        modifier(CardBackground())
    }
}
