//
//  Day16Tests.swift
//  aoc-2020Tests
//
//  Created by Markus Krischke on 16.12.20.
//

import XCTest

class Day16Tests: XCTestCase {
    
    struct Rule {
        let name: String
        let ranges: [ClosedRange<Int>]
        
        func isValid(_ value: Int) -> Bool {
            return ranges.contains(where: { $0.contains(value) })
        }
    }

    func testDay16_1() throws {
        let data = loadData()
        var sum = 0
        
        for ticket in data.nearbyTickets {
            for value in ticket {
                if !data.rules.contains(where: { $0.isValid(value) }) {
                    sum += value
                }
            }
        }
        XCTAssertEqual(sum, 29759)
    }
    
    func testDay16_2() throws {
        let data = loadData()
        
        let validTickets = data.nearbyTickets.filter { ticket in
            return ticket.allSatisfy { value in
                data.rules.contains(where: { $0.isValid(value) })
            }
        }
        
        var ruleIndex: [Int: [Rule]] = Dictionary(uniqueKeysWithValues: zip(0..<data.rules.count, Array(repeating: data.rules, count: 20)))
        
        for ticket in validTickets {
            for (index, value) in ticket.enumerated() {
                ruleIndex[index] = ruleIndex[index]?.filter { $0.isValid(value) }
            }
        }
        
        var sortedIndex = ruleIndex.sorted { (lhs, rhs) -> Bool in
            return lhs.value.count < rhs.value.count
        }
        
        for (index, entry) in sortedIndex.enumerated() {
            for key in index + 1..<ruleIndex.count {
                sortedIndex[key].value = sortedIndex[key].value.filter { !entry.value.map { $0.name }.contains($0.name) }
            }
        }
        
        let departureRules = sortedIndex.filter { $0.value.contains(where: { $0.name.starts(with: "departure") }) }
        XCTAssertEqual(departureRules.count, 6)
        
        var result = 1
        for d in departureRules {
            result *= data.ticket[d.key]
        }
        XCTAssertEqual(result, 1307550234719)
    }

    private func loadData() -> (rules: [Rule], ticket: [Int], nearbyTickets: [[Int]]) {
        let sections = loadFile(name: "day16.txt").components(separatedBy: "\n\n").map { $0.split(separator: "\n") }
        
        let rules = sections[0].map { line -> Rule in
            let parts = line.components(separatedBy: ": ")
            let ranges = parts[1].components(separatedBy: " or ").map { $0.split(separator: "-") }.map { Int($0[0])!...Int($0[1])! }
            return Rule(name: parts[0], ranges: ranges)
        }

        let ticket = sections[1][1].split(separator: ",").map { Int($0)! }
        
        let nearbyTickets = sections[2].dropFirst().map { $0.split(separator: ",").map { Int($0)! } }
        
        return (rules, ticket, nearbyTickets)
    }
}
