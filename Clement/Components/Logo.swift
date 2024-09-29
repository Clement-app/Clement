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
            Image(.logo).resizable()
                .scaledToFit()
                .frame(width: 40)
                .foregroundColor(.accent)
            Text("Clement").font(.system(.largeTitle, design: .rounded))
                .fontWeight(.heavy)
                .foregroundStyle(.accent)
        }
    }
}

#Preview {
    Logo()
}
