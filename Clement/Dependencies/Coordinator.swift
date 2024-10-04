//
//  Coordinator.swift
//  Clement
//
//  Created by Alex Catchpole on 28/09/2024.
//

import Foundation
import Dependencies
import SwiftData
import Shared

protocol CoordinatorProtocol {
    func applyEnabledRuleLists() async throws
    func refreshAvailableRules() async throws
    func shouldUpdate() -> Bool
}

enum CoordinatorError: Error {
    case downloadFailed
}

class Coordinator: CoordinatorProtocol {
    
    @Dependency(\.fileIO) var fileIO
    @Dependency(UserDefaultsKey.self) var userDefaults
    @Dependency(\.generator) var generator
    @Dependency(\.contentBlocker) var contentBlocker
    @Dependency(\.downloader) var downloader
    @Dependency(\.date.now) var now
    @Dependency(ModelContainerKey.self) var modelContainer
    
    func refreshAvailableRules() async throws {
        var availableRules: [RuleList]
        
        do {
            availableRules = try await downloader.availableItems()
        } catch {
            print("can't fetch available items")
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
        
        let localContext = ModelContext(modelContainer)
        for rule in availableRules {
            if let existingRule = try localContext.fetch(FetchDescriptor<RuleList>(predicate: #Predicate { $0.key == rule.key })).first {
                existingRule.name = rule.name
                existingRule.url = rule.url
                existingRule.type = rule.type
            } else {
                localContext.insert(rule)
            }
        }
        try localContext.save()
        
        try await applyEnabledRuleLists()
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
     Create our content blocker JSONs from our enabled filter lists
     */
    func applyEnabledRuleLists() async throws {
        let fetchDescriptor = FetchDescriptor<RuleList>()
        
        let localContext = ModelContext(modelContainer)
        let rules = try localContext.fetch(fetchDescriptor)
        
        let groupedByType = Dictionary(grouping: rules, by: \.type)
        
        let keys = groupedByType.keys.sorted()
        try await keys.asyncForEach { key in
            guard let rules = (groupedByType[key])?.filter({ rule in rule.enabled }) else {
                print("rules don't exist for key: \(key)")
                return
            }
            
            guard let typeEnum = RuleListType(rawValue: key) else {
                print("invalid enum")
                return
            }
            
            let fileName = "\(typeEnum.rawValue).json"

            guard !rules.isEmpty else {
                // Delete content blocker if we had one
                fileIO.delete(fileName)
                userDefaults.set(0, forKey: userDefaults.keyForType(type: typeEnum))
                return
            }
            
            let (json, count) = try generator.generateContentBlockerJSON(rules)
            userDefaults.set(count, forKey: userDefaults.keyForType(type: typeEnum))
            try fileIO.writeString(fileName, json)
        }
        try await contentBlocker.refreshExtension([.core, .annoyance, .privacy])
    }
}

extension Coordinator: DependencyKey {
    static let liveValue = Coordinator()
}
