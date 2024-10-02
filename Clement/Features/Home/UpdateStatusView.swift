//
//  StatusView.swift
//  Clement
//
//  Created by Alex Catchpole on 30/09/2024.
//

import SwiftUI

enum UpdateStatus {
    case updated
    case updating
}

struct UpdateStatusView: View {
    var status: UpdateStatus
    
    @AppStorage(UserDefaults.Keys.lastUpdated.rawValue) var lastUpdated: Date?
    
    @ViewBuilder
    func leadingView() -> some View {
        switch (status) {
        case .updated:
            Image(systemName: "checkmark.shield.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 28)
                .foregroundStyle(Color.green5)
        case .updating:
            ProgressView().tint(Color.green5)
        }
    }
    
    var statusText: String {
        get {
            switch (status) {
            case .updated:
                return "You're up to date"
            case .updating:
                return "Updating filter lists..."
            }
        }
    }
    
    var lastUpdatedText: String? {
        get {
            guard let lastUpdatedDate = lastUpdated else {
                return nil
            }
            return lastUpdatedDate.formattedString()
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                leadingView()
                Text(statusText).font(.system(.title, design: .rounded))
                    .fontWeight(.heavy)
                    .foregroundStyle(.green5)
            }
            if let updatedText = lastUpdatedText {
                Text("Last updated \(updatedText)").font(.system(.caption, design: .rounded)).foregroundStyle(.green5)
            }
        }.frame(maxWidth: .infinity, minHeight: 150).cardBackground()
    }
}

#Preview {
    UpdateStatusView(status: .updating)
}
