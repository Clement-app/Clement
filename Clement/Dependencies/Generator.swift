//
//  Generator.swift
//  Clement
//
//  Created by Alex Catchpole on 03/10/2024.
//

/**
 Given a set of rule lists models, the generator will create content blocker JSON files
 */

import Foundation
import Dependencies

struct Generator {
    var generateContentBlockerJSON: (_ ruleLists: [RuleList]) throws -> (json: String, ruleCount: Int)
}


extension Generator: DependencyKey {
    static var liveValue: Self {
        @Dependency(\.parser) var parser
        @Dependency(\.fileIO) var fileIO
        return Self { ruleLists in
            let combinedText = try ruleLists.reduce("") {
                $0 + "\n" + (try fileIO.getString("\($1.key).txt"))
            }
            
            let parsedBlockerJSON = parser.parseRuleList(combinedText)
            
            // Parse to figure out number of rules
            let ruleCount = (try JSONSerialization.jsonObject(with: parsedBlockerJSON.data(using: .utf8)!) as? Array<Any>)?.count ?? 0
            return (parsedBlockerJSON, ruleCount)
        }
    }
}

extension DependencyValues {
  var generator: Generator {
    get { self[Generator.self] }
    set { self[Generator.self] = newValue }
  }
}

