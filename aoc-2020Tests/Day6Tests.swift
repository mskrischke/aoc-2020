//
//  Day6Tests.swift
//  aoc-2020Tests
//
//  Created by Markus Krischke on 05.12.20.
//

import XCTest

class Day6Tests: XCTestCase {

    func testDay6_1() throws {
        let count = loadData().map { Set($0.replacingOccurrences(of: "\n", with: "")).count }.reduce(0, +)
        XCTAssertEqual(count, 6947)
    }

    func testDay6_2() throws {
        let count = loadData()
            .map { $0.components(separatedBy: "\n").filter { !$0.isEmpty } }
            .map { $0.reduce(into: Set($0[0])) { $0.formIntersection($1) }.count }
            .reduce(0, +)
        XCTAssertEqual(count, 3398)
    }

    private func loadData() -> [String] {
        return loadFile(name: "day6.txt").components(separatedBy: "\n\n").filter { !$0.isEmpty }
    }
}
