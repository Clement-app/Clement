//
//  CoordinatorTests.swift
//  ClementTests
//
//  Created by Alex Catchpole on 01/10/2024.
//

import Testing
import Foundation
import Dependencies
import SwiftData

struct CoordinatorTests {
    
    init() {
        let fileManager = FileManager()
        let folderURL = fileManager.getDocumentsDirectory()
        
        let blockListPath = folderURL.appendingPathComponent("blocklist.json")
        let demoTextPath = folderURL.appendingPathComponent("demo.txt")
        
        try? fileManager.removeItem(at: blockListPath)
        try? fileManager.removeItem(at: demoTextPath)
        
        #expect(fileManager.fileExists(atPath: blockListPath.path()) == false)
        #expect(fileManager.fileExists(atPath: demoTextPath.path()) == false)
    }

    @Test("shouldUpdate() returns true if an update has never happened")
    func shouldUpdate_neverHappened() throws {
        let defaults = UserDefaults(suiteName: "shouldUpdate_neverHappened")!
        defaults.removePersistentDomain(forName: "shouldUpdate_neverHappened")
        
        let coordinatorWithOldDate = withDependencies {
            $0.date.now = Date.now
            $0[UserDefaultsKey.self] = defaults
        } operation: {
            Coordinator()
        }
        #expect(coordinatorWithOldDate.shouldUpdate() == true)
    }
    
    @Test("shouldUpdate() returns true if the last update was over 24 hours ago")
    func shouldUpdate_over24HoursAgo() throws {
        
        // Update occurred 24h 1m ago
        let now = Date.now
        let withHours = Calendar.current.date(byAdding: .hour, value: -24, to: now)!
        let oldDate = Calendar.current.date(byAdding: .minute, value: -1, to: withHours)!
        
        let defaults = UserDefaults(suiteName: "shouldUpdate_over24HoursAgo")!
        defaults.removePersistentDomain(forName: "shouldUpdate_over24HoursAgo")
        defaults.set(oldDate.rawValue, forKey: UserDefaults.Keys.lastUpdated.rawValue)
        
        let coordinatorWithOldDate = withDependencies {
            $0.date.now = now
            $0[UserDefaultsKey.self] = defaults
        } operation: {
            Coordinator()
        }
        #expect(coordinatorWithOldDate.shouldUpdate() == true)
    }
    
    @Test("shouldUpdate() returns false if the last update was in the last 24 hours")
    func shouldUpdate_inTheLast24Hours() throws {
        
        // Update occurred 23h 30m ago
        let now = Date.now
        let withHours = Calendar.current.date(byAdding: .hour, value: -23, to: now)!
        let oldDate = Calendar.current.date(byAdding: .minute, value: -30, to: withHours)!
        
        let defaults = UserDefaults(suiteName: "shouldUpdate_inTheLast24Hours")!
        defaults.removePersistentDomain(forName: "shouldUpdate_inTheLast24Hours")
        defaults.set(oldDate.rawValue, forKey: UserDefaults.Keys.lastUpdated.rawValue)
        
        let coordinatorWithOldDate = withDependencies {
            $0.date.now = now
            $0[UserDefaultsKey.self] = defaults
        } operation: {
            Coordinator()
        }
        #expect(coordinatorWithOldDate.shouldUpdate() == false)
    }
    
    @Test("refreshAvailableRules() throws an error if we fail to fetch available rules")
    func refreshAvailableRules_failsToFetchAvailableRules() async throws {
        let defaults = UserDefaults(suiteName: "refreshAvailableRules_failsToFetchAvailableRules")!
        defaults.removePersistentDomain(forName: "refreshAvailableRules_failsToFetchAvailableRules")
        
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: RuleList.self, configurations: config)
        
        let coordinator = withDependencies {
            $0.date.now = Date.now
            $0[UserDefaultsKey.self] = defaults
            $0.downloader.availableItems = { throw URLError(.badServerResponse) }
        } operation: {
            Coordinator()
        }
        
        await #expect(throws: Error.self) {
            try await coordinator.refreshAvailableRules(with: container)
        }
    }
    
    @Test("refreshAvailableRules() throws an error if we fail to download one of the filter lists")
    func refreshAvailableRules_failsToDownloadTextFile() async throws {
        let defaults = UserDefaults(suiteName: "refreshAvailableRules_failsToDownloadTextFile")!
        defaults.removePersistentDomain(forName: "refreshAvailableRules_failsToDownloadTextFile")
        
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: RuleList.self, configurations: config)
        
        let coordinator = withDependencies {
            $0.date.now = Date.now
            $0[UserDefaultsKey.self] = defaults
            $0.downloader = Downloader(availableItems: { return [
                RuleList(key: "demo", name: "demo", url: "https://hello.com")
            ] }, downloadRules: { ruleList in
                throw URLError(.badServerResponse)
            })
        } operation: {
            Coordinator()
        }
        
        await #expect(throws: Error.self) {
            try await coordinator.refreshAvailableRules(with: container)
        }
    }
    
    @MainActor
    @Test("refreshAvailableRules writes the available rules to .txt files and correctly updates Swift Data with our models")
    func refreshAvailableRules_worksAsExpected() async throws {
        let defaults = UserDefaults(suiteName: "refreshAvailableRules_worksAsExpected")!
        defaults.removePersistentDomain(forName: "refreshAvailableRules_worksAsExpected")
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: RuleList.self, configurations: config)
        let fileManager = FileManager()
        
        let filterListKey = "demo"
        let filterListName = "demo"
        let filterListUrl = "https://google.com"
        let filterListText = "all of my filter rules in my filter list"
        
        let coordinator = withDependencies {
            $0.date.now = Date.now
            $0[UserDefaultsKey.self] = defaults
            $0[FileManagerKey.self] = fileManager
            $0.downloader = Downloader(availableItems: { return [
                RuleList(key: filterListKey, name: filterListName, url: filterListUrl)
            ] }, downloadRules: { ruleList in
                return filterListText
            })
        } operation: {
            Coordinator()
        }
        
        try await coordinator.refreshAvailableRules(with: container)
        
        // Expect file to have been written
        let folderURL = fileManager.getDocumentsDirectory()
        let fileURL = folderURL.appendingPathComponent("demo.txt")
        
        // Expect file to exist and for text to equal the filter rule text
        #expect(fileManager.fileExists(atPath: fileURL.path()) == true)
        #expect(try String(contentsOf: fileURL, encoding: .utf8) == filterListText)
        
        //Expect that the rule has been written to core data
        let descriptor = FetchDescriptor<RuleList>()
        let items = try container.mainContext.fetch(descriptor)
        #expect(items.count == 1)
        
        let firstItem = items.first
        #expect(firstItem?.key == filterListKey)
        #expect(firstItem?.name == filterListName)
        #expect(firstItem?.url == filterListUrl)
    }
    
    @Test("applyEnabledRuleLists() should generate correct blocklist based on enabled rules")
    func applyEnabledRuleLists_shouldGenerateBlockList() async throws {
        let defaults = UserDefaults(suiteName: "applyEnabledRuleLists_shouldGenerateBlockList")!
        defaults.removePersistentDomain(forName: "applyEnabledRuleLists_shouldGenerateBlockList")
        
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: RuleList.self, configurations: config)
        let context = ModelContext(container)
        
        let fileManager = FileManager()
        
        let rules = [
            RuleList(key: "demo", name: "demo", url: "https://google.com"),
            RuleList(key: "demo2", name: "demo2", url: "https://google2.com", enabled: false),
        ]
        for rule in rules {
            context.insert(rule)
        }
        try context.save()
        
        let coordinator = withDependencies {
            $0.date.now = Date.now
            $0[UserDefaultsKey.self] = defaults
            $0[FileManagerKey.self] = fileManager
            $0.fileIO.getString = { _ in
"""
-consent-banner-
-consent-banner.
-cookie-banner-$script
-cookie-banner.
-cookie-bar.
-cookie-cnil.
"""
            }
        } operation: {
            Coordinator()
        }
        
        try coordinator.applyEnabledRuleLists(with: container)
        
        // Expect file to have been written
        let folderURL = fileManager.getDocumentsDirectory()
        let blockListPath = folderURL.appendingPathComponent("blocklist.json")
        #expect(fileManager.fileExists(atPath: blockListPath.path()) == true)
    }
}
