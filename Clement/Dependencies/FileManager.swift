//
//  FileManager.swift
//  Clement
//
//  Created by Alex Catchpole on 01/10/2024.
//

import Foundation
import Dependencies

extension FileManager: @unchecked @retroactive Sendable {
}

enum FileManagerKey: DependencyKey {
    static let liveValue = FileManager.default
    static let testValue = FileManager.default
}
