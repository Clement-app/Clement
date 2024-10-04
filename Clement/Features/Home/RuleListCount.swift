//
//  RuleListCount.swift
//  Clement
//
//  Created by Alex Catchpole on 03/10/2024.
//

import SwiftUI

struct RuleListCount: View {
    @AppStorage(UserDefaults.Keys.coreTotalRules.rawValue) var coreTotalRules: Int = 0
    @AppStorage(UserDefaults.Keys.privacyTotalRules.rawValue) var privacyTotalRules: Int = 0
    @AppStorage(UserDefaults.Keys.annoyanceTotalRules.rawValue) var annoyanceTotalRules: Int = 0
    @AppStorage(UserDefaults.Keys.exclusionTotalRules.rawValue) var exclusionTotalRules: Int = 0
    
    var body: some View {
        VStack {
            HStack {
                Text("Core")
                    .foregroundStyle(.green5)
                    .font(.system(.headline))
                    .multilineTextAlignment(.leading)
                Spacer()
                Text("\(coreTotalRules) rules").foregroundStyle(.green5).font(.system(.subheadline))
            }
            Divider()
            HStack {
                Text("Privacy")
                    .foregroundStyle(.green5)
                    .font(.system(.headline))
                    .multilineTextAlignment(.leading)
                Spacer()
                Text("\(privacyTotalRules) rules").foregroundStyle(.green5).font(.system(.subheadline))
            }
            Divider()
            HStack {
                Text("Annoyance")
                    .foregroundStyle(.green5)
                    .font(.system(.headline))
                    .multilineTextAlignment(.leading)
                Spacer()
                Text("\(annoyanceTotalRules) rules").foregroundStyle(.green5).font(.system(.subheadline))
            }
            Divider()
            HStack {
                Text("Exclusions")
                    .foregroundStyle(.green5)
                    .font(.system(.headline))
                    .multilineTextAlignment(.leading)
                Spacer()
                Text("\(exclusionTotalRules) rules").foregroundStyle(.green5).font(.system(.subheadline))
            }
        }
        .padding(12)
        .background(Color.chalk)
        .cornerRadius(12)
    }
}

#Preview {
    RuleListCount()
}
