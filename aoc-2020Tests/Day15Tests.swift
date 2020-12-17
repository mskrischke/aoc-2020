//
//  Day15Tests.swift
//  aoc-2020Tests
//
//  Created by Markus Krischke on 15.12.20.
//

import XCTest

class Day15Tests: XCTestCase {

    func testDay15_1() throws {
        let tests = ["0,3,6": 436, "1,3,2": 1, "2,1,3": 10, "12,20,0,6,1,17,7" : 866]
        
        for entry in tests {
            XCTAssertEqual(playMemory(startEntries: entry.key, iterations: 2020), entry.value)
        }
    }

    func testDay15_2() throws {
        let tests = ["12,20,0,6,1,17,7" : 1437692]
        
        for entry in tests {
            XCTAssertEqual(playMemory(startEntries: entry.key, iterations: 30000000), entry.value)
        }
    }
    
    private func playMemory(startEntries: String, iterations: Int) -> Int {
        let starting = startEntries.split(separator: ",").map { Int($0)! }
        var memory = starting + Array(repeating: -1, count: iterations - starting.count)
        var lastIndexOf = Array(repeating: -1, count: iterations)
        for entry in starting.dropLast().enumerated() {
            lastIndexOf[entry.element] = entry.offset
        }
        
        for index in starting.count..<memory.count {
            let previousNumber = memory[index - 1]
            
            let lastIndex = lastIndexOf[previousNumber]
            if lastIndex != -1 {
                memory[index] = (index - 1) - lastIndex
            } else {
                memory[index] = 0
            }
            lastIndexOf[previousNumber] = index - 1
        }
        
        return memory.last!
    }
}
