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
            }
        } label: {
            HStack{
                Image(systemName: setting.iconSystemName)    .renderingMode(.template)
                    .foregroundColor(.accentColor)
                    .frame(width: 25, height: 25)
                Text(setting.title)
                Spacer()
            }
        }
    }
}

struct SettingsView: View {
    let settings = [
        SettingGroup(title: "Filters", settings: [
            Setting(title: "Filter lists", iconSystemName: "line.3.horizontal.decrease", route: .DebugSettings),
            Setting(title: "Exclusions", iconSystemName: "x.circle", route: .DebugSettings),
            Setting(title: "Updates", iconSystemName: "arrow.down.circle", route: .DebugSettings),
        ]),
        SettingGroup(title: "General", settings: [
            Setting(title: "About & acknowledgements", iconSystemName: "info.circle", route: .DebugSettings),
            Setting(title: "Debug Settings", iconSystemName: "ant.circle", route: .DebugSettings),
        ])
    ]
    var body: some View {
        List(settings) { section in
            Section(section.title) {
                ForEach(section.settings) { setting in
                    SettingsViewItem(setting: setting)
                }
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView()
}
