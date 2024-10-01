//
//  Coordinator.swift
//  Clement
//
//  Created by Alex Catchpole on 28/09/2024.
//

import Foundation
import Dependencies
import SwiftData

protocol CoordinatorProtocol {
    func applyEnabledRuleLists() async throws
    func refreshAvailableRules(with container: ModelContainer) async throws
    func shouldUpdate() -> Bool
}

enum CoordinatorError: Error {
    case downloadFailed
}

class Coordinator: CoordinatorProtocol {
    
    @Dependency(UserDefaultsKey.self) var userDefaults
    @Dependency(DownloaderKey.self) var downloader
    @Dependency(ParserKey.self) var parser
    @Dependency(\.date.now) var now
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func refreshAvailableRules(with container: ModelContainer) async throws {
        let availableRules = try await downloader.availableItems()
        
        // Generate a block list from the specified rules
        for ruleList in availableRules {
            guard let text = try await downloader.downloadRules(ruleList: ruleList) else {
                throw CoordinatorError.downloadFailed
            }
            try text.write(to: getDocumentsDirectory().appendingPathComponent("\(ruleList.key).txt"), atomically: true, encoding: .utf8)
        }
        
        let localContext = ModelContext(container)
        for rule in availableRules {
            localContext.insert(rule)
        }
        try localContext.save()
        
        userDefaults.set(now.rawValue, forKey: UserDefaults.Keys.lastUpdated.rawValue)
    }
    
    /**
     Determine if we should update if 24 hours has passed since the last update
     */
    func shouldUpdate() -> Bool {
        guard let lastUpdated = userDefaults.date(forKey: UserDefaults.Keys.lastUpdated.rawValue) else {
            return true
        }
        // 24 hours
        let timeToLive: TimeInterval = 60 * 60 * 24
        let elapsed = Date().timeIntervalSince(lastUpdated)
        return elapsed > timeToLive
    }
    
    /**
     Fetch rules from either the API or cache, download each one and create our content blocker JSON
     */
    func applyEnabledRuleLists() async throws {
    }
}

extension Coordinator: DependencyKey {
    static let liveValue = Coordinator()
}
