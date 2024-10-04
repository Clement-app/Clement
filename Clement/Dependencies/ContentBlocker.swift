//
//  ClementContentBlockerManager.swift
//  Clement
//
//  Created by Alex Catchpole on 23/09/2024.
//

import SafariServices
import Dependencies
import Shared

struct ContentBlocker {
    var isEnabled: (_ type: [RuleListType]) async -> Bool
    var refreshExtension: (_ type: [RuleListType]) async throws -> Void
}

extension ContentBlocker {
    
    static var coreIdentifier: String = "uk.co.catchpoledigital.Clement.SafariExtension"
    static var privacyIdentifier: String = "uk.co.catchpoledigital.Clement.PrivacySafariExtension"
    static var annoyanceIdentifier: String = "uk.co.catchpoledigital.Clement.AnnoyancesSafariExtension"
    static var exclusionsIdentifier: String = "uk.co.catchpoledigital.Clement.ExclusionsSafariExtension"
    
    static func getBundleIdentifiers(for types: [RuleListType]) -> [String] {
        return types.map { getBundleIdentifiers(for: $0) }.flatMap { $0 }
    }
    
    static private func getBundleIdentifiers(for type: RuleListType) -> [String] {
        switch type {
        case .core:
            return [coreIdentifier]
        case .privacy:
            return [privacyIdentifier]
        case .annoyance:
            return [annoyanceIdentifier]
        case .exclusions:
            return [exclusionsIdentifier]
        }
    }
    
}

extension ContentBlocker: DependencyKey {
    static var liveValue: Self {
        return Self(
            isEnabled: { types in
                do {
                    let identifiers = ContentBlocker.getBundleIdentifiers(for: types)
                    return try await identifiers.asyncMap { try await SFContentBlockerManager.stateOfContentBlocker(withIdentifier: $0).isEnabled }.allSatisfy({ $0 == true})
                } catch {
                    return false
                }
            },
            refreshExtension: { types in
                let identifiers = ContentBlocker.getBundleIdentifiers(for: types)
                try await identifiers.asyncForEach { try await SFContentBlockerManager.reloadContentBlocker(withIdentifier: $0) }
            }
        )
    }
}

extension DependencyValues {
  var contentBlocker: ContentBlocker {
    get { self[ContentBlocker.self] }
    set { self[ContentBlocker.self] = newValue }
  }
}

