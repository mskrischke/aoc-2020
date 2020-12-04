//
//  Day4Tests.swift
//  aoc-2020Tests
//
//  Created by Markus Krischke on 04.12.20.
//

import XCTest

class Day4Tests: XCTestCase {

    typealias Passport = [Key: String]

    enum Key: String, CaseIterable {
        case byr, iyr, eyr, hgt, hcl, ecl, pid
    }

    enum EyeColor: String {
        case amb, blu, brn, gry, grn, hzl, oth
    }

    func testDay4_1() throws {
        let passports = loadData()
        let validPassports = passports.filter { Set($0.keys) == Set(Key.allCases) }.count
        XCTAssertEqual(validPassports, 254)
    }

    func testDay4_2() throws {
        let passports = loadData()
        let validPassports = passports.filter { Set($0.keys) == Set(Key.allCases) }.filter(isValid(_:))
        XCTAssertEqual(validPassports.count, 184)
    }

    private func isValid(_ passport: Passport) -> Bool {
        guard let birth = Int(passport[.byr]!), birth >= 1920 && birth <= 2002 else {
            return false
        }

        guard let issue = Int(passport[.iyr]!), issue >= 2010 && issue <= 2020 else {
            return false
        }

        guard let exp = Int(passport[.eyr]!), exp >= 2020 && exp <= 2030 else {
            return false
        }

        let height = passport[.hgt]!
        if let r = height.range(of: "cm"), let i = Int(height.prefix(upTo: r.lowerBound)), i >= 150 && i <= 193 {}
        else if let r = height.range(of: "in"), let i = Int(height.prefix(upTo: r.lowerBound)), i >= 59 && i <= 76 {}
        else { return false }

        guard passport[.hcl]!.matches("#[0-9a-f]{6}") else {
            return false
        }

        guard EyeColor(rawValue: passport[.ecl]!) != nil else {
            return false
        }

        guard let pid = passport[.pid], pid.count == 9, Int(pid) != nil else {
            return false
        }

        return true
    }

    private func loadData() -> [Passport] {
        let lines = loadFile(name: "day4.txt").components(separatedBy: "\n\n")
            .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        return lines.map { line -> [Key: String] in
            let parts = line.components(separatedBy: CharacterSet(charactersIn: "\n "))
            let splitParts = parts.map { $0.components(separatedBy: ":") }
            let keyValues = splitParts.compactMap { t -> (Key, String)? in
                guard let key = Key(rawValue: t[0]) else { return nil }
                return (key, t[1])
            }
            return Dictionary(keyValues, uniquingKeysWith: { lhs, rhs in lhs })
        }
    }
}
