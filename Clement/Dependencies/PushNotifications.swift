//
//  FirebaseManager.swift
//  Clement
//
//  Created by Alex Catchpole on 07/10/2024.
//

import SwiftUI
import Dependencies
import FirebaseMessaging

protocol PushNotificationsProtocol: MessagingDelegate {
    func requestAuthorization() -> Void
    func getFCMToken() async throws -> String?
    func registerFCMToken(_ token: Data) -> Void
}

class LivePushNotifications: NSObject, PushNotificationsProtocol {
    override init() {
        super.init()
        Messaging.messaging().delegate = self
    }
    
    deinit {
        Messaging.messaging().delegate = nil
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.provisional]) { (granted, error) in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    func getFCMToken() async throws -> String? {
        return try await Messaging.messaging().token()
    }
    
    func registerFCMToken(_ token: Data) {
        Messaging.messaging().setAPNSToken(token, type: .unknown)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        Messaging.messaging().subscribe(toTopic: Constants.backgroundRefreshTopic)
    }
}

enum PushNotificationsKey: DependencyKey {
    static var liveValue: PushNotificationsProtocol = LivePushNotifications()
}

extension DependencyValues {
  var pushNotifications: PushNotificationsProtocol {
    get { self[PushNotificationsKey.self] }
    set { self[PushNotificationsKey.self] = newValue }
  }
}


