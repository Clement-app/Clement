//
//  Settings.swift
//  Clement
//
//  Created by Alex Catchpole on 29/09/2024.
//

import SwiftUI

struct SettingsViewItem: View {
    var setting: Setting
    
    var body: some View {
        NavigationLink {
            switch(setting.route) {
            case .DebugSettings:
                DebugView()
            case .filterLists:
                FilterListView()
            }
        } label: {
            HStack{
                Image(systemName: setting.iconSystemName)
                    .renderingMode(.template)
                    .foregroundColor(Color.green5)
                    .frame(width: 25, height: 25)
                Text(setting.title).foregroundStyle(Color.green5)
                Spacer()
            }
        }
    }
}

struct SettingsView: View {
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.accent]
    }
    
    let settings = [
        SettingGroup(title: "Filters", settings: [
            Setting(title: "Filter lists", iconSystemName: "line.3.horizontal.decrease", route: .filterLists),
            Setting(title: "Exclusions", iconSystemName: "x.circle", route: .DebugSettings),
        ]),
        SettingGroup(title: "General", settings: [
            Setting(title: "About & acknowledgements", iconSystemName: "info.circle", route: .DebugSettings),
            Setting(title: "Debug settings", iconSystemName: "ant.circle", route: .DebugSettings),
        ]),
        SettingGroup(title: "Premium", settings: [
            Setting(title: "Restore purchases", iconSystemName: "arrow.clockwise", route: .DebugSettings),
        ])
    ]
    var body: some View {
        BackgroundView(content: {
            List(settings) { section in
                Section(section.title) {
                    ForEach(section.settings) { setting in
                        SettingsViewItem(setting: setting).listRowBackground(Color.chalk)
                    }
                }.foregroundStyle(Color.accentColor)
            }.scrollContentBackground(.hidden)
        }, color: Color.green5)
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView()
}
