//
//  Downloader.swift
//  Clement
//
//  Created by Alex Catchpole on 28/09/2024.
//

import Foundation
import Dependencies

struct Downloader {
    var availableItems: () async throws -> [RuleList]
    var downloadRules: (_ ruleList: RuleList) async throws -> String?
}

struct AvailableItemsAPIResponse: Codable {
    var sources: [RuleList]
}

extension Downloader: DependencyKey {
    static var liveValue: Self {
        return Self(availableItems: {
            guard let url = URL(string: "https://api.clement.app/available") else {
                throw URLError(.badURL)
            }
            let response: AvailableItemsAPIResponse = try await URLSession.shared.decode(from: url)
            return response.sources
        }, downloadRules: { (ruleList: RuleList) in
            guard let url = URL(string: ruleList.url) else {
                throw URLError(.badURL)
            }
            let (data, _) = try await URLSession.shared.data(from: url)
            return String(bytes: data, encoding: .utf8)
        })
    }
    
    static let testValue = Self(
        availableItems: unimplemented("Downloader.availableItems"),
        downloadRules: unimplemented("Downloader.downloadRules")
    )
}

extension DependencyValues {
  var downloader: Downloader {
    get { self[Downloader.self] }
    set { self[Downloader.self] = newValue }
  }
}
