//
//  ClementApp.swift
//  Clement
//
//  Created by Alex Catchpole on 23/09/2024.
//

import SwiftUI
import Dependencies
import SwiftData

enum ModelContainerKey: DependencyKey {
    static var liveValue: ModelContainer = {
        let schema = Schema([
            Item.self,
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
    
    @Dependency(CoordinatorKey.self) var coordinator
    @AppStorage(Constants.HAS_ONBOARDED) var hasOnboared: Bool = false

    var body: some Scene {
        WindowGroup {
            ZStack{
                Color.background.ignoresSafeArea()
                Home()
//                if !hasOnboared {
//                    OnboardingView()
//                } else {
//                    Home()
//                }
            }
        
        }
        .modelContainer(modelContainer)
    }
}
