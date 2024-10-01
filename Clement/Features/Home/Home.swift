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
        @Dependency(ModelContainerKey.self) var modelContainer
        
        @ObservationIgnored
        @Dependency(Coordinator.self) var coordinator
        
        var isShowingSetupSheet: Bool = false
        var status = UpdateStatus.updated
        
        func ensureExtensionEnabled() async {
            isShowingSetupSheet = await !contentBlocker.isEnabled
        }
        
        func refreshFilterLists() async {
            guard coordinator.shouldUpdate() else {
                return
            }
            status = .updating
            do {
                try await coordinator.refreshAvailableRules(with: modelContainer)
                status = .updated
            } catch {
                print(error)
            }
        }
    }
}

struct Home: View {
    @Environment(\.scenePhase) var scenePhase
    @State var viewModel = ViewModel()
    
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            VStack {
                Logo()
                Spacer()
                UpdateStatusView(status: viewModel.status)
                Spacer()
                AsyncButton {
                
                } label: {
                    Text("Check for updates")
                        .frame(maxWidth: 300, maxHeight: 40)
                }.buttonStyle(.bordered)
                NavigationLink {
                    SettingsView()
                } label: {
                    Text("Settings").frame(maxWidth: 300, maxHeight: 40)
                }
            }
            .padding(20)
            .sheet(isPresented: $viewModel.isShowingSetupSheet) {
                SetupView().interactiveDismissDisabled()
            }

            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .active {
                    Task {
                        await viewModel.ensureExtensionEnabled()
                    }
                }
            }.task {
                await viewModel.refreshFilterLists()
            }
        }
    }
}

#Preview {
    Home()
}
