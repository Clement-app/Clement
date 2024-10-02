//
//  UserDefaults+Extensions.swift
//  Clement
//
//  Created by Alex Catchpole on 01/10/2024.
//

import Foundation

extension UserDefaults {
    enum Keys: String, CaseIterable {
        case hasOnboarded
        case lastUpdated
        case totalRules
    }
    
    func reset() {
        Keys.allCases.forEach { removeObject(forKey: $0.rawValue) }
    }
    
    func date(forKey: String) -> Date? {
        guard let dateString = string(forKey: forKey) else { return nil }
        return Date(rawValue: dateString)
    }
}
