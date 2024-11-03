//
//  DebugView.swift
//  Clement
//
//  Created by Alex Catchpole on 30/09/2024.
//

import SwiftUI
import Dependencies

extension DebugView {
    @Observable
    class ViewModel {
        
        @ObservationIgnored
        @Dependency(UserDefaultsKey.self) var userDefaults
        
        @ObservationIgnored
        @Dependency(\.pushNotifications.self) var pushNotifications
        
        var fcmToken: String = ""
        
        func resetUserDefaults() {
            userDefaults.reset()
        }
        
        func fetchFCMToken() async {
            do {
                fcmToken = try await pushNotifications.getFCMToken() ?? "Token not available"
            } catch {
                fcmToken = "Token not available"
            }
        }
        
        func copyFCMToken() {
            UIPasteboard.general.string = fcmToken
        }
    }
}

struct DebugView: View {
    @State var viewModel = ViewModel()
    
    var body: some View {
        BackgroundView {
            Form {
                Section("FCM Push Token") {
                    Button {
                        viewModel.copyFCMToken()
                    } label: {
                        Text(viewModel.fcmToken).foregroundStyle(.green5)
                    }.listRowBackground(Color.chalk)
                }
                Section {
                    Button {
                        viewModel.resetUserDefaults()
                    } label: {
                        Text("Reset UserDefaults").foregroundStyle(.green5)
                    }.listRowBackground(Color.chalk)
                }
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Debug Settings")
        .onAppear {
            Task {
                await viewModel.fetchFCMToken()
            }
        }
    }
}

#Preview {
    DebugView()
}
