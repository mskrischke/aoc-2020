//
//  Utilities.swift
//  aoc-2020Tests
//
//  Created by Markus Krischke on 04.12.20.
//

import Foundation
import XCTest

extension XCTestCase {

    func loadFile(name: String) -> String {
        guard let url = Bundle(for: Self.self).url(forResource: name, withExtension: nil),
              let data = try? Data(contentsOf: url),
              let result = String(data: data, encoding: .utf8) else {
            preconditionFailure("Could not load file \(name)")
        }
        return result
    }
}

extension String {

    func match(_ pattern: String) -> [NSTextCheckingResult] {
        let regex = try! NSRegularExpression(pattern: pattern)
        return regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
    }

    func matches(_ pattern: String) -> Bool {
        return !match(pattern).isEmpty
    }
    
    func padLeft(toSize: Int, with padding: String) -> String {
        return String(repeating: padding, count: toSize - self.count) + self
    }
}
