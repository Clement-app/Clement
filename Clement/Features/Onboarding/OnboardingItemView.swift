//
//  OnboardingItemView.swift
//  Clement
//
//  Created by Alex Catchpole on 23/09/2024.
//

import SwiftUI

struct OnboardingItemView: View {
    var item: OnboardingItem
    
    var body: some View {
        ZStack {
          VStack(spacing: 20) {
            // FRUIT: IMAGE
              HStack(spacing: 20) {
                  Image(item.image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                    .foregroundStyle(.accent)
                  // FRUIT: TITLE
                  Text(item.title)
                      .foregroundStyle(.chalk)
                      .font(.largeTitle)
                      .fontWeight(.heavy)
                      .multilineTextAlignment(.center)
                
              }
            
            // FRUIT: HEADLINE
            Text(item.headline)
                  .foregroundColor(.chalk)
              .multilineTextAlignment(.center)
              .padding(.horizontal, 16)
              .frame(maxWidth: 480)
              .multilineTextAlignment(.center)
            
          }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .padding(.horizontal, 20)
    }
}

#Preview {
    OnboardingItemView(item: OnboardingItem(title: "Time & Data Superstar", headline: "Web pages load a lot faster with Wipr, and much less needs to be downloaded. Your mobile devices will love this.", image: "OnboardingOne"))
}
