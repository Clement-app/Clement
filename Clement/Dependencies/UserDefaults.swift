//
//  UserDefaults.swift
//  Clement
//
//  Created by Alex Catchpole on 24/09/2024.
//
import Foundation
import Dependencies

extension UserDefaults: @unchecked @retroactive Sendable {
}

enum UserDefaultsKey: DependencyKey {
  static let liveValue = UserDefaults.standard
}
