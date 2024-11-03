//
//  Background.swift
//  Clement
//
//  Created by Alex Catchpole on 08/10/2024.
//

import Dependencies

enum BackgroundError: Error {
    case malformedNotification
}

struct Background {
    var handleRemoteNotification: (_ userInfo: [String: Any]) async throws -> Void
}

extension Background: DependencyKey {
    static var liveValue: Self {
        @Dependency(Coordinator.self) var coordinator
        return Self { userInfo in
            guard let silentNotification = userInfo["aps"] as? [String: AnyObject], silentNotification["content-available"] as? Int == 1 else {
                throw BackgroundError.malformedNotification
            }
            try await coordinator.refreshAvailableRules()
        }
    }
}

extension DependencyValues {
  var background: Background {
    get { self[Background.self] }
    set { self[Background.self] = newValue }
  }
}
