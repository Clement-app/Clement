//
//  ClementContentBlockerManager.swift
//  Clement
//
//  Created by Alex Catchpole on 23/09/2024.
//

import SafariServices
import Dependencies

protocol ContentBlockerProtocol {
    var isEnabled: Bool { get async }
}

class LiveContentBlocker: ContentBlockerProtocol {
    var isEnabled: Bool {
        get async {
            do {
                let status = try await SFContentBlockerManager.stateOfContentBlocker(withIdentifier: "uk.co.catchpoledigital.Clement.SafariExtension")
                return status.isEnabled
            } catch {
                return false
            }
        }
    }
}

enum ContentBlockerKey: DependencyKey {
    static let liveValue: any ContentBlockerProtocol = LiveContentBlocker()
}
