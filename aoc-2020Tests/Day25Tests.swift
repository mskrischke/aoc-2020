//
//  Day25Tests.swift
//  aoc-2020Tests
//
//  Created by Markus Krischke on 25.12.20.
//

import XCTest

class Day25Tests: XCTestCase {

    func testDay25_1() throws {
        XCTAssertEqual(findLoopSize(subject: 7, publicKey: 5764801), 8)
        XCTAssertEqual(findLoopSize(subject: 7, publicKey: 17807724), 11)
        let sampleEncryptionKey = transform(loopSize: findLoopSize(subject: 7, publicKey: 17807724), subject: 5764801)
        XCTAssertEqual(sampleEncryptionKey, 14897079)
        
        XCTAssertEqual(findLoopSize(subject: 7, publicKey: 8184785), 14570644)
        XCTAssertEqual(findLoopSize(subject: 7, publicKey: 5293040), 1707612)
    
        let encryptionKey = transform(loopSize: findLoopSize(subject: 7, publicKey: 5293040), subject: 8184785)
        XCTAssertEqual(encryptionKey, 4126980)
    }
    
    private func findLoopSize(subject: Int, publicKey: Int) -> Int {
        var value = 1
        var loopSsize = 0
        while value != publicKey {
            value *= subject
            value = value.remainderReportingOverflow(dividingBy: 20201227).partialValue
            loopSize += 1
        }
        return loopSize
    }
    
    private func transform(loopSize: Int, subject: Int) -> Int {
        var value = 1
        for _ in 0..<loopSize {
            value *= subject
            value = value.remainderReportingOverflow(dividingBy: 20201227).partialValue
        }
        return value
    }
    
    func testDay25_2() throws {
    }
}
