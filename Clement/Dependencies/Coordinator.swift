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
    func applyEnabledRuleLists(with container: ModelContainer) async throws
    func refreshAvailableRules(with container: ModelContainer) async throws
    func shouldUpdate() -> Bool
}

enum CoordinatorError: Error {
    case downloadFailed
}

class Coordinator: CoordinatorProtocol {
    
    @Dependency(\.fileIO) var fileIO
    @Dependency(UserDefaultsKey.self) var userDefaults
    @Dependency(\.downloader) var downloader
    @Dependency(\.parser) var parser
    @Dependency(\.date.now) var now
    
    func refreshAvailableRules(with container: ModelContainer) async throws {
        var availableRules: [RuleList]
        
        do {
            availableRules = try await downloader.availableItems()
        } catch {
            throw CoordinatorError.downloadFailed
        }
        
        // Generate a block list from the specified rules
        for ruleList in availableRules {
            do {
                guard let text = try await downloader.downloadRules(ruleList) else {
                    throw CoordinatorError.downloadFailed
                }
                try fileIO.writeString("\(ruleList.key).txt", text)
            } catch {
                throw CoordinatorError.downloadFailed
            }
        }
        
        let localContext = ModelContext(container)
        for rule in availableRules {
            localContext.insert(rule)
        }
        try localContext.save()
        
        try applyEnabledRuleLists(with: container)
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
    
    func printTimeElapsedWhenRunningCode(title:String, operation:()->()) {
        let startTime = CFAbsoluteTimeGetCurrent()
        operation()
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        print("Time elapsed for \(title): \(timeElapsed) s.")
    }
    
    /**
     Create our content blocker JSON from our enabled filter lists
     */
    func applyEnabledRuleLists(with container: ModelContainer) throws {
        let fetchDescriptor = FetchDescriptor<RuleList>(predicate: #Predicate { $0.enabled == true })
        
        let localContext = ModelContext(container)
        let rules = try localContext.fetch(fetchDescriptor)
        let combinedText = try rules.reduce("") {
            $0 + "\n" + (try fileIO.getString("\($1.key).txt"))
        }
        
        let parsedBlockerJSON = parser.parseRuleList(combinedText)
        try fileIO.writeString("blocklist.json", parsedBlockerJSON)
        
        guard let jsonCount = (try JSONSerialization.jsonObject(with: parsedBlockerJSON.data(using: .utf8)!) as? Array<Any>)?.count else {
            return
        }
        userDefaults.set(jsonCount, forKey: UserDefaults.Keys.totalRules.rawValue)
    }
}

extension Coordinator: DependencyKey {
    static let liveValue = Coordinator()
}
