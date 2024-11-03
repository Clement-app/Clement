//
//  Home.swift
//  Clement
//
//  Created by Alex Catchpole on 24/09/2024.
//

import SwiftUI
import Dependencies
import SwiftData

extension Home {
    @Observable
    class ViewModel {
        @ObservationIgnored
        @Dependency(\.contentBlocker) var contentBlocker
        
        @ObservationIgnored
        @Dependency(ModelContainerKey.self) var modelContainer
        
        @ObservationIgnored
        @Dependency(Coordinator.self) var coordinator
        
        var isShowingSetupSheet: Bool = false
        var isShowingRuleViewer: Bool = false
        var status = UpdateStatus.updated
        var selectedRule: RuleList?
        
        func ensureExtensionEnabled() async {
            isShowingSetupSheet = await !contentBlocker.isEnabled([.core, .annoyance, .privacy, .exclusions])
        }
        
        func showRuleViewer(ruleList: RuleList) {
            selectedRule = ruleList
            isShowingRuleViewer = true
        }
        
        private func refresh() async {
            status = .updating
            do {
                try await coordinator.refreshAvailableRules()
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
    }
}

struct Home: View {
    @Environment(\.scenePhase) var scenePhase
    
    @State var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            BackgroundView {
                VStack() {
                    HStack {
                        Logo()
                        Spacer()
                        NavigationLink {
                            SettingsView()
                        } label: {
                            Image(systemName: "gear")
                                .resizable()
                                .frame(width: 28, height: 28)
                        }
                    }
                    .padding([.top, .leading, .trailing], 28)
                    ScrollView {
                        VStack(spacing: 14) {
                            UpdateStatusView(status: viewModel.status)
                            AsyncButton {
                                await viewModel.refreshFilterLists(force: true)
                            } label: {
                                Text("Check for updates").foregroundStyle(Color.green5).frame(maxWidth: .infinity, minHeight: 40)
                            }.buttonStyle(.borderedProminent).tint(.accent)
                            RuleListCount()
                            FilterRulesList(showRuleViewer: viewModel.showRuleViewer)
                        }
                    }
                }.contentMargins([.bottom, .leading, .trailing], 28, for: .scrollContent)
            }
            .sheet(isPresented: $viewModel.isShowingSetupSheet) {
                SetupView().interactiveDismissDisabled()
            }
            .sheet(isPresented: $viewModel.isShowingRuleViewer) {
                RuleViewer(ruleList: viewModel.selectedRule)
            }
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .active {
                    Task {
                        await viewModel.ensureExtensionEnabled()
                    }
                }
            }.onAppear() {
                Task {
                    await viewModel.refreshFilterLists()
                }
            }
        }
    }
}

#Preview {
    Home()
}
