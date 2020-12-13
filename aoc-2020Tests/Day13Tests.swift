//
//  Day13Tests.swift
//  aoc-2020Tests
//
//  Created by Markus Krischke on 13.12.20.
//

import XCTest

class Day13Tests: XCTestCase {

    let arrival: Float = 1001287
    let schedule = "13,x,x,x,x,x,x,37,x,x,x,x,x,461,x,x,x,x,x,x,x,x,x,x,x,x,x,17,x,x,x,x,19,x,x,x,x,x,x,x,x,x,29,x,739,x,x,x,x,x,x,x,x,x,41,x,x,x,x,x,x,x,x,x,x,x,x,23"
    
    func testDay13_1() throws {
        let busIds = schedule.split(separator: ",").compactMap { Float($0) }
        let best = busIds.map { (ceil(arrival / $0) * $0 - arrival, $0) }.min(by: { $0.0 < $1.0 })
        XCTAssertEqual(best!.0 * best!.1, 2305)
    }
    
    func testDay13_2() throws {
//        let tests = ["7,13,x,x,59,x,31,19": 1068781, "17,x,13,19": 3417, "67,7,59,61": 754018, "67,x,7,59,61": 779210, "67,7,x,59,61": 1261476]
//        for entry in tests {
//            XCTAssertEqual(find(schedule: entry.key), entry.value)
//        }
        XCTAssertEqual(find(schedule: schedule), 552612234243498)
    }
    
    private func find(schedule: String) -> Int {
        let busIds = schedule.split(separator: ",").enumerated().compactMap { Int($0.element) != nil ? (Int($0.element)!, $0.offset) : nil }
        var factors = busIds
        var number = 0
        var stepSize = 1
        
        while true {
            let b = factors.first!
            if (number + b.1) % b.0 == 0 {
                factors.removeFirst()
                stepSize *= b.0
            }
            
            if busIds.allSatisfy({(number + $0.1) % $0.0 == 0}) {
                return number
            }
            
            number += stepSize
        }
    }
}
