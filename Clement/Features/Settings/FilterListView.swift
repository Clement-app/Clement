//
//  RuleLists.swift
//  Clement
//
//  Created by Alex Catchpole on 03/10/2024.
//

import SwiftUI
import Dependencies
import SwiftData

struct FilterListRow: View {
    var ruleList: RuleList
    var onChangeCallback: ((_ status: Bool) -> Void)?
    
    @State private var isOn: Bool
    
    
    init(ruleList: RuleList, onChange: ((_ status: Bool) -> Void)? = nil) {
        self.ruleList = ruleList
        self._isOn = State(initialValue: ruleList.enabled)
        self.onChangeCallback = onChange
    }
    
    var body: some View {
        
        HStack {
            Toggle(ruleList.name, isOn: $isOn)
                .tint(.green3)
                .foregroundStyle(.green5)
        }
        .listRowBackground(Color.chalk)
        .onChange(of: isOn) { oldValue, newValue in
            self.onChangeCallback?(newValue)
        }
    }
}

extension FilterListView {
    @Observable
    class ViewModel {
        @ObservationIgnored
        @Dependency(ModelContainerKey.self) var modelContainer
        
        @ObservationIgnored
        @Dependency(Coordinator.self) var coordinator
        
        var filterLists: Dictionary<String, [RuleList]> = [:]
        var localContext: ModelContext?

        
        func loadFilterList()  {
            localContext = ModelContext(modelContainer)
            let fetchDescriptor = FetchDescriptor<RuleList>()
            do {
                filterLists = Dictionary(grouping: try localContext!.fetch(fetchDescriptor), by: \.type)
            } catch {
                print("error fetching")
            }
        }
        
        func updateFilterListEnabled(ruleList: RuleList, enabled: Bool) {
            ruleList.enabled = enabled
        }
        
        func saveChanges() async {
            guard let context = localContext else {
                print("context no exist")
                return
            }
            do {
                try context.save()
                try await coordinator.applyEnabledRuleLists()
            } catch {
                print(error)
            }
        }
    }
}

struct FilterListView: View {
    @State var viewModel = ViewModel()
    
    var body: some View {
        BackgroundView {
            List {
                ForEach(viewModel.filterLists.keys.sorted(), id: \.self) { key in
                    Section(key) {
                        ForEach(viewModel.filterLists[key] ?? [], id: \.key) { ruleList in
                            FilterListRow(ruleList: ruleList) { enabled in
                                viewModel.updateFilterListEnabled(ruleList: ruleList, enabled: enabled)
                            }
                        }
                    }.foregroundStyle(Color.accentColor)
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Filter Lists")
            .toolbar {
                AsyncButton("Save") {
                    await viewModel.saveChanges()
                }
            }
            .onAppear {
                viewModel.loadFilterList()
            }
        }
    }
}

#Preview {
    FilterListView()
}
