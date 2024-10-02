//
//  Logo.swift
//  Clement
//
//  Created by Alex Catchpole on 24/09/2024.
//

import SwiftUI

struct Logo: View {
    var body: some View {
        HStack {
            Image(.logo)
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .foregroundColor(.white)
            Text("Clement").font(.system(.largeTitle, design: .rounded))
                .fontWeight(.heavy)
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    Logo()
}
