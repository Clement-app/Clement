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
import Firebase
import FirebaseMessaging

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

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    @Dependency(\.background) var background
    @Dependency(\.pushNotifications) var pushNotifications
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        pushNotifications.requestAuthorization()
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
        print("BACKGROUND NOTIFICATION")
        guard let notification = userInfo as? [String: Any] else {
            print("MALFORMED JSON \(userInfo)")
            return .failed
        }
        
        do {
            try await background.handleRemoteNotification(notification)
            print("[BACKGROUND] - Successfully refreshed")
            return .newData
        } catch {
            print("[BACKGROUND] - Error refreshing available rules: \(error)")
            return .failed
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        pushNotifications.registerFCMToken(deviceToken)
    }

}

@main
struct ClementApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
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
