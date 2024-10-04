//
//  FilterRulesList.swift
//  Clement
//
//  Created by Alex Catchpole on 02/10/2024.
//

import SwiftUI
import Dependencies
import SwiftData

struct FilterRulesList: View {
    
    var showRuleViewer: (_ ruleList: RuleList) -> Void
    @Query(sort: [SortDescriptor(\RuleList.type, order: .forward)]) var ruleLists: [RuleList]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            ForEach(ruleLists) {ruleList in
                Button {
                    showRuleViewer(ruleList)
                } label: {
                    VStack(alignment: .leading) {
                        HStack(alignment: .center) {
                            Text(ruleList.name)
                                .foregroundStyle(.green5)
                                .font(.system(.headline))
                                .multilineTextAlignment(.leading)
                            Spacer()
                            Text(ruleList.type.uppercased()).foregroundStyle(Color.green3).font(.system(.caption2, weight: .bold))
                        }
                        if ruleList.id != ruleLists.last?.id {
                            Divider()
                        }
                    }
                }
            }
        }
        .padding(12)
        .background(Color.chalk)
        .cornerRadius(12)
    }
}

#Preview {
    FilterRulesList(showRuleViewer: { list in
        print(list)
    })
}
