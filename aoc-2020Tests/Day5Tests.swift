//
//  Day5Tests.swift
//  aoc-2020Tests
//
//  Created by Markus Krischke on 05.12.20.
//

import XCTest

class Day5Tests: XCTestCase {

    func testDay5_1() throws {
        XCTAssertEqual(567, ticketId(for: "BFFFBBFRRR"))
        XCTAssertEqual(119, ticketId(for: "FFFBBBFRRR"))
        XCTAssertEqual(820, ticketId(for: "BBFFBBFRLL"))

        let tickets = loadData()
        XCTAssertEqual(818, tickets.map(ticketId(for:)).sorted().last)
    }

    func testDay5_2() throws {
        let tickets = loadData()
        let ticketIds = tickets.map(ticketId(for:)).sorted()
        let allAvailableSeats = Set(ticketIds.first! ... ticketIds.last!)
        let remaining = allAvailableSeats.subtracting(ticketIds)
        XCTAssertEqual(remaining.first, 559)
    }

    private func ticketId(for input: String) -> Int {
        return Int(input.replacingOccurrences(of: "F", with: "0")
            .replacingOccurrences(of: "B", with: "1")
            .replacingOccurrences(of: "L", with: "0")
            .replacingOccurrences(of: "R", with: "1"), radix: 2)!
    }

    private func loadData() -> [String] {
        return loadFile(name: "day5.txt").components(separatedBy: "\n").filter { !$0.isEmpty }
    }
}
