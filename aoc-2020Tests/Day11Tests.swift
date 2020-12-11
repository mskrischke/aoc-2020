//
//  Day11Tests.swift
//  aoc-2020Tests
//
//  Created by Markus Krischke on 11.12.20.
//

import XCTest

class Day11Tests: XCTestCase {

    typealias Layout = [[Seat]]

    enum Seat: String {
        case floor = "."
        case free = "L"
        case taken = "#"
    }

    enum Adjacent: CaseIterable {
        case left, bottomLeft, bottomCenter, bottomRight, right, topRight, topCenter, topLeft

        var dir: (Int, Int) {
            switch self {
            case .left:
                return (0, -1)
            case .bottomLeft:
                return (1, -1)
            case .bottomCenter:
                return (1, 0)
            case .bottomRight:
                return (1, 1)
            case .right:
                return (0, 1)
            case .topRight:
                return (-1, 1)
            case .topCenter:
                return (-1, 0)
            case .topLeft:
                return (-1, -1)
            }
        }
    }

    func testDay11_1() throws {
        var layout = parse(loadFile(name: "day11.txt"))
        var changes = Int.max

        while changes != 0 {
            let result = mutate(layout, takenTolerance: 4, sight: false)
            layout = result.0
            changes = result.1
        }

        let takenSeats = layout.flatMap { $0 }.filter { $0 == .taken }.count
        XCTAssertEqual(takenSeats, 2222)
    }

    func testDay11_2() throws {
        var layout = parse(loadFile(name: "day11.txt"))
        var changes = Int.max

        while changes != 0 {
            let result = mutate(layout, takenTolerance: 5, sight: true)
            layout = result.0
            changes = result.1
            debug(layout)
        }

        let takenSeats = layout.flatMap { $0 }.filter { $0 == .taken }.count
        XCTAssertEqual(takenSeats, 2032)
    }

    private func debug(_ layout: Layout) {
        for row in layout {
            for column in row {
                print(column.rawValue, separator: "", terminator: "")
            }
            print("")
        }
        print("----------")
    }

    private func mutate(_ layout: Layout, takenTolerance: Int, sight: Bool) -> (Layout, Int) {
        var newLayout = layout
        var changes = 0

        for (rowIndex, row) in layout.enumerated() {
            for (columnIndex, seat) in row.enumerated() {
                guard seat != .floor else { continue }

                let adjacents = Adjacent.allCases.compactMap { layout.seat(row: rowIndex, column: columnIndex, adjacent: $0, sight: sight) }

                if seat == .free && !adjacents.contains(.taken) {
                    newLayout[rowIndex][columnIndex] = .taken
                    changes += 1
                } else if seat == .taken && adjacents.filter({ $0 == .taken }).count >= takenTolerance {
                    newLayout[rowIndex][columnIndex] = .free
                    changes += 1
                }
            }
        }
        return (newLayout, changes)
    }

    private func parse(_ data: String) -> Layout {
        data.components(separatedBy: "\n").filter { !$0.isEmpty }.map { $0.compactMap { Seat(rawValue: String($0)) } }
    }
}

private extension Array where Element == Array<Day11Tests.Seat> {

    func seat(row: Int, column: Int, adjacent: Day11Tests.Adjacent, sight: Bool) -> Day11Tests.Seat? {
        let dir = adjacent.dir
        var r = row
        var c = column

        var seat: Day11Tests.Seat?
        while true {
            r += dir.0
            c += dir.1

            guard r >= 0 && r < count else { return nil }
            guard c >= 0 && c < self[r].count else { return nil }

            seat = self[r][c]
            if seat != .floor || !sight {
                return seat
            }
        }
    }
}
