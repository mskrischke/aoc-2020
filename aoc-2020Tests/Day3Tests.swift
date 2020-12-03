//
//  Day3Tests.swift
//  aoc-2020Tests
//
//  Created by Markus Krischke on 03.12.20.
//

import XCTest

class Day3Tests: XCTestCase {

    struct Pos { var x, y: Int }

    struct Map {
        enum Surface: Character {
            case open = "."
            case tree = "#"
        }

        var input: [[Surface]] = []

        public subscript(pos: Pos) -> Surface? {
            guard !input.isEmpty, pos.y < input.count else {
                return nil
            }

            let xPos = pos.x % input[0].count
            return input[pos.y][xPos]
        }
    }

    struct Navigator {
        let map: Map
        var position: Pos

        mutating func move(right: Int, down: Int) -> Map.Surface? {
            position.x += right
            position.y += down
            print("XXX Moved to position: \(position)")
            return map[position]
        }
    }

    func testDay3_1() throws {
        let map = loadData()
        var nav = Navigator(map: map, position: .init(x: 0, y: 0))

        var surface = nav.move(right: 3, down: 1)
        var treesHit = 0
        while surface != nil {
            if surface == .tree {
                treesHit += 1
            }
            surface = nav.move(right: 3, down: 1)
        }

        XCTAssertEqual(treesHit, 173)
    }

    func testDay3_2() throws {
//        Right 1, down 1.
//        Right 3, down 1. (This is the slope you already checked.)
//        Right 5, down 1.
//        Right 7, down 1.
//        Right 1, down 2.

        let map = loadData()
        let movementPatterns = [(1,1), (3,1), (5,1), (7,1), (1,2)]
        var multipliedMoves = 1

        for pattern in movementPatterns {
            var nav = Navigator(map: map, position: .init(x: 0, y: 0))

            var surface = nav.move(right: pattern.0, down: pattern.1)
            var treesHit = 0
            while surface != nil {
                if surface == .tree {
                    treesHit += 1
                }
                surface = nav.move(right: pattern.0, down: pattern.1)
            }

            print("XXX Pattern \(pattern) hit \(treesHit) trees")
            multipliedMoves *= treesHit
        }

        XCTAssertEqual(multipliedMoves, 4385176320)
    }

    private func loadData() -> Map {
        do {
            let url = Bundle(for: Self.self).url(forResource: "day3", withExtension: "txt")!
            let data = try Data(contentsOf: url)
            let lines = String(data: data, encoding: .utf8)?.split(separator: "\n").map { String($0) } ?? []

            let entries = lines.map { (line: String) -> [Map.Surface] in
                return line.map { Map.Surface(rawValue: $0)! }
            }
            return Map(input: entries)
        } catch {
            XCTFail(error.localizedDescription)
            preconditionFailure()
        }
    }

}
