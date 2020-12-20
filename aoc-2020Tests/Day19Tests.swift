//
//  Day19Tests.swift
//  aoc-2020Tests
//
//  Created by Markus Krischke on 19.12.20.
//

import XCTest

class Day19Tests: XCTestCase {

    func testDay19_1() throws {
       ///\ba((aa|bb)(ab|ba)|(ab|ba)(aa|bb))b\b
        let data = loadData()
        let count = solve(rules: data.rules, messages: data.messages)
        XCTAssertEqual(count, 195)
    }

    func testDay19_2() throws {
        let data = loadData()

        var rules = data.rules
//        rules["8"] = "42 | 42 8"
//        rules["11"] = "42 31 | 42 11 31"
        rules["8"] = "42+"
        rules["11"] = (1..<5).map { (Array(repeating: "42", count: $0) + Array(repeating: "31", count: $0)).joined(separator: " ") }.joined(separator: " | ")

        let count = solve(rules: rules, messages: data.messages)
        XCTAssertEqual(count, 309)
    }

    private func solve(rules input: [String: String], messages: [String]) -> Int {
        var rules = input
        let keys = rules.keys
        for key in keys where key != "0" {
            let rule = rules[key]!
            rules[key] = nil

            for entry in rules {
                var value = entry.value
                if rule.contains("\"") {
                    value = value.replacingOccurrences(of: "\\b\(key)\\b", with: "\(rule.replacingOccurrences(of: "\"", with: ""))", options: [.regularExpression])
                } else {
                    value = value.replacingOccurrences(of: "\\b\(key)\\b", with: "(\(rule))", options: [.regularExpression])
                }
                rules[entry.key] = value
            }
        }

        let exp = "\\b\(rules["0"]!.replacingOccurrences(of: " ", with: ""))\\b"
        print(exp)

        return messages.filter { $0.matches(exp) }.count
    }

    private func loadData() -> (rules: [String: String], messages: [String]) {
        let data = loadFile(name: "day19.txt").components(separatedBy: "\n\n")

        let rules = Dictionary<String, String>(uniqueKeysWithValues: data[0].split(separator: "\n").map {
            let parts = $0.components(separatedBy: ": ")
            return (String(parts[0]), String(parts[1]))
        })

        return (rules, data[1].components(separatedBy: "\n"))
    }
}
