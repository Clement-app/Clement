//
//  ClementApp.swift
//  Clement
//
//  Created by Alex Catchpole on 23/09/2024.
//

import SwiftUI
import Dependencies
import SwiftData
import IssueReporting

enum ModelContainerKey: DependencyKey {
    static var liveValue: ModelContainer = {
        let schema = Schema([
            RuleList.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
}

@main
struct ClementApp: App {
    
    @Dependency(ModelContainerKey.self) var modelContainer
    
    @Dependency(Coordinator.self) var coordinator
    
    @AppStorage(UserDefaults.Keys.hasOnboarded.rawValue) var hasOnboarded: Bool = false

    var body: some Scene {
        WindowGroup {
            if !isTesting {
                if !hasOnboarded {
                    OnboardingView()
                } else {
                    Home()
                }
            }
        }
        .modelContainer(modelContainer)
    }
}
