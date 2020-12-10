//
//  Day10Tests.swift
//  aoc-2020Tests
//
//  Created by Markus Krischke on 10.12.20.
//

import XCTest
import Algorithms

class Day10Tests: XCTestCase {

    func testDay10_1() throws {
        let adapters = loadData().sorted()

        let jolts = [0] + adapters + [adapters.last! + 3]
        var diffs: [Int: Int] = [:]

        for (index, jolt) in jolts.enumerated() where index < jolts.count - 1 {
            let diff = jolts[index + 1] - jolt
            diffs[diff, default: 0] += 1
        }

        XCTAssertEqual(diffs[1]! * diffs[3]!, 2100)
    }

    func testDay10_2() throws {
        let adapters = loadData().sorted()

        let jolts = [0] + adapters + [adapters.last! + 3]
        var routes: [Int: Int] = [0: 1]

        for jolt in jolts[1...] {
            let m1 = routes[jolt - 1, default: 0]
            let m2 = routes[jolt - 2, default: 0]
            let m3 = routes[jolt - 3, default: 0]
            routes[jolt] = m1 + m2 + m3
        }

        XCTAssertEqual(routes[jolts.last!], 16198260678656)
    }

    private func loadData() -> [Int] {
        return loadFile(name: "day10.txt").components(separatedBy: "\n").compactMap { Int($0) }
    }
}
