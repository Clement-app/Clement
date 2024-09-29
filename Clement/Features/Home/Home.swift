//
//  Home.swift
//  Clement
//
//  Created by Alex Catchpole on 24/09/2024.
//

import SwiftUI
import Dependencies

extension Home {
    @Observable
    class ViewModel {
        @ObservationIgnored
        @Dependency(ContentBlockerKey.self) var contentBlocker
        
        @ObservationIgnored
        @Dependency(CoordinatorKey.self) var coordinator
        
        @ObservationIgnored
        @Dependency(ModelContainerKey.self) var modelContainer
        
        var isShowingSetupSheet: Bool = false
        
        func ensureExtensionEnabled() async {
            isShowingSetupSheet = await !contentBlocker.isEnabled
        }
        
        func refreshAvailableRules() async {
            try! await coordinator.refreshAvailableRules(with: modelContainer)
        }
    }
}

struct Home: View {
    @Environment(\.scenePhase) var scenePhase
    @State var viewModel = ViewModel()
    
    @Environment(\.modelContext) private var modelContext

    
    var body: some View {
        VStack {
            Logo()
            Spacer()
            VStack {
                HStack {
                    Image("ShieldCheck")
                      .resizable()
                      .scaledToFit()
                      .frame(height: 30)
                      .foregroundStyle(.accent)
                    Text("You're up to date").font(.system(.largeTitle, design: .rounded))
                        .fontWeight(.heavy)
                        .foregroundStyle(.accent)
                }
                Text("Last updated 12/12/12 15:03").font(.system(.caption, design: .rounded))
            }
            Spacer()
            AsyncButton {
            
            } label: {
                Text("Check for updates")
                    .frame(maxWidth: 300, maxHeight: 40)
            }.buttonStyle(.bordered)
            AsyncButton {
            
            } label: {
                Text("Settings")
                    .frame(maxWidth: 300, maxHeight: 40)
            }
        }
        .padding(20)
        .sheet(isPresented: $viewModel.isShowingSetupSheet) {
            SetupView().interactiveDismissDisabled()
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
//            if newPhase == .active {
//                Task {
//                    await viewModel.ensureExtensionEnabled()
//                }
//            }
        }
        .task {
            await viewModel.refreshAvailableRules()
        }
    }
}

#Preview {
    ZStack {
        Color.background.ignoresSafeArea()
        Home()
    }
}
