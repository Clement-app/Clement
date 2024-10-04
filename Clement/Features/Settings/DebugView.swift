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
        
        func resetUserDefaults() {
            userDefaults.reset()
        }
    }
}

struct DebugView: View {
    
    @State var viewModel = ViewModel()
    
    var body: some View {
        BackgroundView {
            Form {
                Section {
                    Button {
                        viewModel.resetUserDefaults()
                    } label: {
                        Text("Reset UserDefaults").foregroundStyle(.green5)
                    }.listRowBackground(Color.chalk)
                }
            }
            .scrollContentBackground(.hidden)
        }.navigationTitle("Debug Settings")
    }
}

#Preview {
    DebugView()
}
