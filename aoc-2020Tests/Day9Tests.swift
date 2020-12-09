//
//  Day9Tests.swift
//  aoc-2020Tests
//
//  Created by Markus Krischke on 09.12.20.
//

import XCTest
import Algorithms

class Day9Tests: XCTestCase {

    func testDay9_1() throws {
        let preamble = 25
        let data = loadData()

        for index in preamble..<data.count {
            let next = data[index]
            let previous = data[index - preamble ..< index]
            let combinations = previous.combinations(ofCount: 2)

            if combinations.first(where: { $0.reduce(0, +) == next }) == nil {
                XCTAssertEqual(next, 177777905)
                break
            }
        }
    }

    func testDay9_2() throws {
        let target = 177777905
        let data = loadData()

        for (index, number) in data.enumerated() {

            var sum = number
            var step = index + 1
            while sum < target {
                sum += data[step]
                step += 1
            }

            if sum == target {
                let range = data[index..<step].sorted()
                XCTAssertEqual(range.first! + range.last!, 23463012)
                break
            }
        }
    }

    private func loadData() -> [Int] {
        return loadFile(name: "day9.txt").components(separatedBy: "\n").compactMap { Int($0) }
    }
}
