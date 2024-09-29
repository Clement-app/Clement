//
//  Coordinator.swift
//  Clement
//
//  Created by Alex Catchpole on 28/09/2024.
//

import Foundation
import Dependencies
import SwiftData

protocol Coordinator {
    func applyEnabledRuleLists() async throws
    func refreshAvailableRules(with container: ModelContainer) async throws
}

enum CoordinatorError: Error {
    case downloadFailed
}

class LiveCoordinator: Coordinator {
    
    @Dependency(DownloaderKey.self) var downloader
    @Dependency(ParserKey.self) var parser
    
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
    }
    
    /**
     Fetch rules from either the API or cache, download each one and create our content blocker JSON
     */
    func applyEnabledRuleLists() async throws {
        
    }
}

enum CoordinatorKey: DependencyKey {
    static let liveValue: any Coordinator = LiveCoordinator()
}
