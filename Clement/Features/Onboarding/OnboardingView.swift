//
//  OnboardingView.swift
//  Clement
//
//  Created by Alex Catchpole on 23/09/2024.
//

import SwiftUI
import Dependencies
import Foundation

extension OnboardingView {
    @Observable
    class ViewModel {
        var isShowingSetupSheet: Bool = false
        
        @ObservationIgnored
        @Dependency(ContentBlockerKey.self) var contentBlocker
        
        @ObservationIgnored
        @Dependency(UserDefaultsKey.self) var userDefaults
        
        func toggleSetupSheet() async {
            if await contentBlocker.isEnabled {
                userDefaults.set(true, forKey: UserDefaults.Keys.hasOnboarded.rawValue)
            } else {
                isShowingSetupSheet.toggle()
            }
        }
    }
}

struct OnboardingView: View {
    let data: [OnboardingItem] = [
        OnboardingItem(title: "A Smooth Experience", headline: "Clement blocks ads, trackers, cookie banners, GDPR notices, and other dodgy content. It works seamlessly in Safari and any app that uses Safari to display web pages.", image: "OnboardingThree"),
        OnboardingItem(title: "Time & Data Superstar", headline: "By blocking unnecessary content, pages load more quickly and consume less data, resulting in a faster browsing experience.", image: "OnboardingOne"),
        OnboardingItem(title: "Always One Step Ahead", headline: "Clement uses a combination of tried and tested filter lists, updated once a day to ensure we're always one step ahead.", image: "OnboardingTwo"),
        OnboardingItem(title: "Privacy First", headline: "Clement uses Safari's 'Content Blocking Extension' feature and doesn't need any special permissions or access to your browsing data.", image: "OnboardingFour")
    ]
    
    @State var viewModel = ViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Logo()
            TabView {
                ForEach(data) { item in
                    OnboardingItemView(item: item)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            AsyncButton {
                await viewModel.toggleSetupSheet()
            } label: {
                Text("Get Started")
                    .frame(maxWidth: 300, maxHeight: 40)
            }.buttonStyle(.borderedProminent)
        }
        .sheet(isPresented: $viewModel.isShowingSetupSheet) {
            SetupView().presentationDetents([.medium]).presentationDragIndicator(.visible)
        }
        .padding(.vertical, 20)
    }
}

#Preview {
    ZStack {
        Color.background.ignoresSafeArea()
        OnboardingView()
    }
}
