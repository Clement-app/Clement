//
//  UserDefaults.swift
//  Clement
//
//  Created by Alex Catchpole on 01/10/2024.
//

import Foundation
import Dependencies

extension UserDefaults: @unchecked @retroactive Sendable {
}

enum UserDefaultsKey: DependencyKey {
    static let liveValue = UserDefaults.standard
}
