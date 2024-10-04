//
//  List.swift
//  Clement
//
//  Created by Alex Catchpole on 28/09/2024.
//
import Foundation
import SwiftData
import Shared


@Model
class RuleList: Codable {
    
    enum CodingKeys: CodingKey {
        case key
        case name
        case url
        case type
        case enabled
    }
    
    @Attribute(.unique) var key: String
    var name: String
    var url: String
    // https://forums.developer.apple.com/forums/thread/738145
    var type: String
    var enabled: Bool = true
    
    init(key: String, name: String, url: String, type: RuleListType, enabled: Bool = true) {
        self.key = key
        self.name = name
        self.url = url
        self.type = type.rawValue
        self.enabled = enabled
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        key = try container.decode(String.self, forKey: .key)
        name = try container.decode(String.self, forKey: .name)
        url = try container.decode(String.self, forKey: .url)
        type = try container.decode(String.self, forKey: .type)
        enabled = try container.decodeIfPresent(Bool.self, forKey: .enabled) ?? true
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(key, forKey: .key)
        try container.encode(name, forKey: .name)
        try container.encode(url, forKey: .url)
        try container.encode(type, forKey: .type)
        try container.encode(enabled, forKey: .enabled)
    }
}
