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

struct Vec3: Hashable {
    static let zero = Vec3(x: 0, y: 0, z: 0)
    
    var x, y, z: Int
    
    var max: Int {
        return [abs(x), abs(y), abs(z)].max()!
    }
    
    static func +(lhs: Vec3, rhs: Vec3) -> Vec3 {
        return Vec3(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }
    
    static func +=(left: inout Vec3, right: Vec3) {
        left = left + right
    }
}

struct Vec2 {
    static let zero = Vec2(x: 0, y: 0)
    
    var x, y: Int
        
    mutating func rotate(angle: Int) {
        let angle = Float(angle) * Float.pi / 180.0
        let newX = Float(x) * cos(angle) - Float(y) * sin(angle)
        let newY = Float(x) * sin(angle) + Float(y) * cos(angle)
        x = Int(round(newX))
        y = Int(round(newY))
    }
    
    static func +(lhs: Vec2, rhs: Vec2) -> Vec2 {
        return Vec2(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func +=(left: inout Vec2, right: Vec2) {
        left = left + right
    }
    
    static func *(lhs: Vec2, rhs: Int) -> Vec2 {
        return Vec2(x: lhs.x * rhs, y: lhs.y * rhs)
    }
}
