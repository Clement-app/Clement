//
//  FileManager+Extensions.swift
//  Clement
//
//  Created by Alex Catchpole on 01/10/2024.
//

import Foundation

extension FileManager {
    func getDocumentsDirectory() -> URL {
        let paths = urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
