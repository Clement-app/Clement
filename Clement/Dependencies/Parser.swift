//
//  Parser.swift
//  Clement
//
//  Created by Alex Catchpole on 28/09/2024.
//

import Dependencies

protocol Parser {
    func parseRuleList(ruleListText: String) -> String
}

class LiveParser: Parser {
    func parseRuleList(ruleListText: String) -> String {
        return parseRules(rules: ruleListText)
    }
}

enum ParserKey: DependencyKey {
    static let liveValue: any Parser = LiveParser()
}
