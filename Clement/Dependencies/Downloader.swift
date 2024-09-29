//
//  Downloader.swift
//  Clement
//
//  Created by Alex Catchpole on 28/09/2024.
//

import Foundation
import Dependencies

protocol Downloader {
    func availableItems() async throws -> [RuleList]
    func downloadRules(ruleList: RuleList) async throws -> String?
}

struct AvailableItemsAPIResponse: Codable {
    var sources: [RuleList]
}

class LiveDownloader: Downloader {
    func availableItems() async throws -> [RuleList] {
        guard let url = URL(string: "https://api.clement.app/available") else {
            throw URLError(.badURL)
        }
        let response: AvailableItemsAPIResponse = try await URLSession.shared.decode(from: url)
        return response.sources
    }
    
    func downloadRules(ruleList: RuleList) async throws -> String? {
        guard let url = URL(string: ruleList.url) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return String(bytes: data, encoding: .utf8)
    }
}

enum DownloaderKey: DependencyKey {
    static let liveValue: any Downloader = LiveDownloader()
}
