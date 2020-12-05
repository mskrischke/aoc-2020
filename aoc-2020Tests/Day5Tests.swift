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
        let row = extractRow(from: input.prefix(7))
        let seat = extractSeat(from: input.suffix(3))
        return row * 8 + seat
    }

    private func extractRow(from input: String.SubSequence) -> Int {
        var row = ClosedRange(uncheckedBounds: (0, 127))

        for c in input {
            let length = row.count / 2
            switch c {
            case "F":
                row = ClosedRange(uncheckedBounds: (row.lowerBound, row.upperBound - length))
            case "B":
                row = ClosedRange(uncheckedBounds: (row.lowerBound + length, row.upperBound))
            default:
                preconditionFailure()
            }
        }
        return row.lowerBound
    }

    private func extractSeat(from input: String.SubSequence) -> Int {
        var row = ClosedRange(uncheckedBounds: (0, 7))

        for c in input {
            let length = row.count / 2
            switch c {
            case "L":
                row = ClosedRange(uncheckedBounds: (row.lowerBound, row.upperBound - length))
            case "R":
                row = ClosedRange(uncheckedBounds: (row.lowerBound + length, row.upperBound))
            default:
                preconditionFailure()
            }
        }
        return row.lowerBound
    }

    private func loadData() -> [String] {
        return loadFile(name: "day5.txt").components(separatedBy: "\n").filter { !$0.isEmpty }
    }
}
