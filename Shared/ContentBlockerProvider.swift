//
//  ContentBlockerProvider.swift
//  Clement
//
//  Created by Alex Catchpole on 03/10/2024.
//

import Foundation

public enum ContentBlockerProviderError: Error {
    case invalidFileUrl
    case invalidNSItemProvider
    case missingBlankJSON
}

/**
 Responsible for providing the JSON file to a safari extension
 */
public class ContentBlockerProvider {
    public init() {}
    public func getJSONAttachmentForType(type: RuleListType) throws -> NSExtensionItem {
        let documentsDirectory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.uk.co.catchpoledigital.Clement")
        guard let archiveURL = documentsDirectory?.appendingPathComponent(fileNameForType(type: type)) else {
            throw ContentBlockerProviderError.invalidFileUrl
        }
        guard FileManager.default.fileExists(atPath: archiveURL.path()) else {
            guard let attachment = NSItemProvider(contentsOf: Bundle.main.url(forResource: "emptyBlockList", withExtension: "json")) else {
                throw ContentBlockerProviderError.missingBlankJSON
            }
            let item = NSExtensionItem()
            item.attachments = [attachment]
            return item
        }
        
        guard let attachment = NSItemProvider(contentsOf: archiveURL) else {
            throw ContentBlockerProviderError.invalidNSItemProvider
        }
        let item = NSExtensionItem()
        item.attachments = [attachment]
        
        return item
    }
    
    private func fileNameForType(type: RuleListType) -> String {
        switch type {
        case .core:
            return "core.json"
        case .privacy:
            return "privacy.json"
        case .annoyance:
            return "annoyance.json"
        case .exclusions:
            return "exclusions.json"
        }
    }
}
