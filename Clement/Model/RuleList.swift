//
//  List.swift
//  Clement
//
//  Created by Alex Catchpole on 28/09/2024.
//
import Foundation
import SwiftData

@Model
class RuleList: Codable {
    
    enum CodingKeys: CodingKey {
        case key
        case name
        case url
        case enabled
    }
    
    @Attribute(.unique) var key: String
    var name: String
    var url: String
    var enabled: Bool = true
    
    init(key: String, name: String, url: String, enabled: Bool = true) {
        self.key = key
        self.name = name
        self.url = url
        self.enabled = enabled
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        key = try container.decode(String.self, forKey: .key)
        name = try container.decode(String.self, forKey: .name)
        url = try container.decode(String.self, forKey: .url)
        enabled = try container.decodeIfPresent(Bool.self, forKey: .enabled) ?? true
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .key)
        try container.encode(name, forKey: .name)
        try container.encode(name, forKey: .url)
        try container.encode(enabled, forKey: .enabled)
    }
}
