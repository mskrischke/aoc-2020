//
//  Day2Tests.swift
//  aoc-2020Tests
//
//  Created by Markus Krischke on 02.12.20.
//

import XCTest

class Day2Tests: XCTestCase {

    struct PasswordEntry {
        var neededRange: ClosedRange<Int>
        var necessaryCharacter: Character
        var password: String

        var isValid: Bool {
            let count = password.filter { $0 == necessaryCharacter }.count
            return neededRange.contains(count)
        }

        var isValid2: Bool {
            return (password[password.index(password.startIndex, offsetBy: neededRange.lowerBound - 1)] == necessaryCharacter) !=
                (password[password.index(password.startIndex, offsetBy: neededRange.upperBound - 1)] == necessaryCharacter)
        }
    }

    func testDay2_1() throws {
        let passwords = loadData()
        let count = passwords.filter({ $0.isValid }).count
        XCTAssertEqual(count, 622)
    }

    func testDay2_2() throws {
        let passwords = loadData()
        let count = passwords.filter({ $0.isValid2 }).count
        XCTAssertEqual(count, 263)
    }

    private func loadData() -> [PasswordEntry] {
        /// 16-19 q: qqqqqqqqfqqfqqqzqqcq
        let lines = loadFile(name: "day2.txt").split(separator: "\n").map { String($0) }

        let entries = lines.map { (line: String) -> PasswordEntry in
            let parts = line.split(separator: " ")

            let rangeParts = parts[0].split(separator: "-")
            let range = ClosedRange<Int>(uncheckedBounds: (Int(rangeParts[0])!, Int(rangeParts[1])!))
            let char = Character(String(parts[1].split(separator: ":")[0]))

            let password = String(parts[2])

            return PasswordEntry(neededRange: range, necessaryCharacter: char, password: password)
        }

        return entries
    }
}
