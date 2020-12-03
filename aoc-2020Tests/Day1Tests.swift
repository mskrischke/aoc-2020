//
//  Day1Tests.swift
//  aoc-2020Tests
//
//  Created by Markus Krischke on 01.12.20.
//

import XCTest

class Day1Tests: XCTestCase {

    func testDay1_1() throws {

        let data = loadData()
        var copy = data

        for i in data {
            if i != 1010 {
                copy.removeAll(where: { $0 == i })
            }

            if let found = data.first(where: { $0 + i == 2020 }) {
                print(found)
                print(i)
                print(found * i)
                XCTAssertEqual(found * i, 41979)
                break
            }
        }
    }

    func testDay1_2() throws {

        let data = loadData()

        data.forEach { index0 in
            data.forEach { index1 in
                if let found = data.first(where: { $0 + index0 + index1 == 2020 }) {
                    print("\(index0), \(index1), \(found): \(index0 * index1 * found)")
                }
            }
        }
    }

    private func loadData() -> [Int] {
        do {
            let url = Bundle(for: Self.self).url(forResource: "day1", withExtension: "txt")!
            let data = try Data(contentsOf: url)
            let s = String(data: data, encoding: .utf8)?.split(separator: "\n").map { String($0) }.compactMap { Int($0) } ?? []
            return s
        } catch {
            XCTFail(error.localizedDescription)
            return []
        }
    }
}
