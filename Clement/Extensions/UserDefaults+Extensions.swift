//
//  UserDefaults+Extensions.swift
//  Clement
//
//  Created by Alex Catchpole on 01/10/2024.
//

import Foundation
import Shared

extension UserDefaults {
    enum Keys: String, CaseIterable {
        case hasOnboarded
        case lastUpdated
        case coreTotalRules
        case privacyTotalRules
        case annoyanceTotalRules
        case exclusionTotalRules
    }
    
    func keyForType(type: RuleListType) -> String {
        switch(type) {
        case .annoyance:
            return Keys.annoyanceTotalRules.rawValue
        case .core:
            return Keys.coreTotalRules.rawValue
        case .privacy:
            return Keys.privacyTotalRules.rawValue
        case .exclusions:
            return Keys.exclusionTotalRules.rawValue
        }
    }
    
    func reset() {
        Keys.allCases.forEach { removeObject(forKey: $0.rawValue) }
    }
    
    func date(forKey: String) -> Date? {
        guard let dateString = string(forKey: forKey) else { return nil }
        return Date(rawValue: dateString)
    }
}
