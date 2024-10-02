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
        
        private func refresh() async {
            status = .updating
            do {
                try await coordinator.refreshAvailableRules(with: modelContainer)
                status = .updated
            } catch {
                print(error)
            }
        }
        
        func refreshFilterLists(force: Bool = false) async {
            if force {
                await refresh()
                return
            }
            guard coordinator.shouldUpdate() else {
                return
            }
            await refresh()
        }
        
        func handleTotalRulesChange(ruleCount: Int) {
            guard ruleCount > Constants.maxRuleCount else {
                return
            }
            print("Over maximum rule count")
        }
    }
}

struct Home: View {
    @Environment(\.scenePhase) var scenePhase
    @State var viewModel = ViewModel()
    
    @Environment(\.modelContext) private var modelContext
    
    @AppStorage(UserDefaults.Keys.totalRules.rawValue) var totalRuleCount: Int = 0
    
    var body: some View {
        NavigationStack {
            BackgroundView {
                VStack() {
                    HStack {
                        Logo()
                        Spacer()
                        Button {
                            
                        } label: {
                            Image(systemName: "gear")
                                .resizable()
                                .frame(width: 28, height: 28)
                        }
                    }
                    ScrollView {
                        VStack(spacing: 14) {
                            UpdateStatusView(status: viewModel.status)
                            ToastView(style: .error, title: "Rule limit reached",message: "There are 196,000 rules enabled, this is over the 150,000 limit enforced by Apple.\n\nYou can disable filter lists in settings.")
                            Form {
                                Section {
                                    Text("erer")
                                    Text("erer")
                                }
                            }
                            Spacer()
                        }
                    }
                }.padding(28)
            }
            .sheet(isPresented: $viewModel.isShowingSetupSheet) {
                SetupView().interactiveDismissDisabled()
            }
            
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .active {
                    Task {
                        await viewModel.ensureExtensionEnabled()
                    }
                }
            }.onAppear() {
                viewModel.handleTotalRulesChange(ruleCount: totalRuleCount)
                Task {
                    await viewModel.refreshFilterLists()
                }
            }.onChange(of: totalRuleCount) {
                viewModel.handleTotalRulesChange(ruleCount: totalRuleCount)
            }
        }
    }
}

#Preview {
    Home()
}
