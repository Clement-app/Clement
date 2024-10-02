//
//  Parser.swift
//  Clement
//
//  Created by Alex Catchpole on 28/09/2024.
//

import Dependencies

struct Parser {
    var parseRuleList: (_ ruleListText: String) -> String
}

extension Parser: DependencyKey {
    static var realParser: Self {
        return Self(
            parseRuleList: { ruleList in parseRules(rules: ruleList) }
        )
    }
    
    static var liveValue = realParser
    static var testValue = realParser
}

extension DependencyValues {
  var parser: Parser {
    get { self[Parser.self] }
    set { self[Parser.self] = newValue }
  }
}

