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
}

extension FileIO: DependencyKey {
    static var realFileIO: Self {
        @Dependency(FileManagerKey.self) var fileManager
        return Self(
            writeString: { fileName, text in
                try text.write(to: fileManager.getDocumentsDirectory().appendingPathComponent(fileName), atomically: true, encoding: .utf8)
            },
            getString: { fileName in
                return try String(contentsOf: fileManager.getDocumentsDirectory().appendingPathComponent(fileName), encoding: .utf8)
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

