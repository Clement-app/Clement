//
//  SettingsItem.swift
//  Clement
//
//  Created by Alex Catchpole on 30/09/2024.
//

enum SettingDestination {
    case DebugSettings
    case filterLists
}

struct SettingGroup: Identifiable {
    var id: String
    var title: String
    var settings: [Setting]
    
    init(title: String, settings: [Setting]) {
        self.id = title
        self.title = title
        self.settings = settings
    }
}

struct Setting: Identifiable {
    var id: String
    var title: String
    var iconSystemName: String
    var route: SettingDestination
    
    init(title: String, iconSystemName: String, route: SettingDestination) {
        self.id = title
        self.title = title
        self.iconSystemName = iconSystemName
        self.route = route
    }
}
