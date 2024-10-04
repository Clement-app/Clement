//
//  RuleViewer.swift
//  Clement
//
//  Created by Alex Catchpole on 02/10/2024.
//

import SwiftUI
import Dependencies

extension RuleViewer {
    @Observable
    class ViewModel {
        
        @ObservationIgnored
        @Dependency(\.fileIO) var fileIO
        
        var rules: [Substring] = []
        
        func loadFile(ruleList: RuleList) {
            do {
                rules = try fileIO.getString("\(ruleList.key).txt").split(whereSeparator: \.isNewline)
            } catch {
                print(error)
            }
        }
    }
}

struct RuleViewer: View {
    @Environment(\.dismiss) var dismiss
    @State var viewModel = ViewModel()
    var ruleList: RuleList?
    
    init(ruleList: RuleList?) {
        self.ruleList = ruleList
        guard let rule = ruleList else { return }
        viewModel.loadFile(ruleList: rule)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(viewModel.rules.indices, id:\.self) { idx in
                        Text(viewModel.rules[idx])
                    }
                }
            }
            .toolbar {
                Button("Close") {
                    dismiss()
                }
            }
            .contentMargins(28, for: .scrollContent)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(ruleList?.name ?? "")
        }
    }
}

#Preview {
//    RuleViewer()
}
