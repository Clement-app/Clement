//
//  FileManager.swift
//  Clement
//
//  Created by Alex Catchpole on 01/10/2024.
//


import Foundation
import Dependencies

struct FileIO {
    var writeString: (_ fileName: String, _ text: String) throws -> Void
    var getString: (_ fileName: String) throws -> String
    var delete: (_ fileName: String) -> Void
}

extension FileIO: DependencyKey {
    static var realFileIO: Self {
        @Dependency(FileManagerKey.self) var fileManager
        return Self(
            writeString: { fileName, text in
                try text.write(to: fileManager.getSharedDirectory().appendingPathComponent(fileName), atomically: true, encoding: .utf8)
            },
            getString: { fileName in
                return try String(contentsOf: fileManager.getSharedDirectory().appendingPathComponent(fileName), encoding: .utf8)
            },
            delete: { fileName in
                try? fileManager.removeItem(at: fileManager.getSharedDirectory().appendingPathComponent(fileName))
            }
        )
    }
    static var liveValue = realFileIO
    static var testValue = realFileIO
}

extension DependencyValues {
  var fileIO: FileIO {
    get { self[FileIO.self] }
    set { self[FileIO.self] = newValue }
  }
}

