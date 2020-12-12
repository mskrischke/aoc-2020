//
//  Day12Tests.swift
//  aoc-2020Tests
//
//  Created by Markus Krischke on 12.12.20.
//

import XCTest

class Day12Tests: XCTestCase {
    
    struct Vec2 {
        var x, y: Int
        
        static let zero = Vec2(x: 0, y: 0)
        
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
        
        static public func +=(left: inout Vec2, right: Vec2) {
            left = left + right
        }
        
        static func *(lhs: Vec2, rhs: Int) -> Vec2 {
            return Vec2(x: lhs.x * rhs, y: lhs.y * rhs)
        }
    }
    
    enum Nav {
        case north(Int), south(Int), east(Int), west(Int), left(Int), right(Int), forward(Int)
        
        init(key: String, value: Int) {
            switch key {
            case "N": self = .north(value)
            case "S": self = .south(value)
            case "E": self = .east(value)
            case "W": self = .west(value)
            case "L": self = .left(value)
            case "R": self = .right(value)
            case "F": self = .forward(value)
            default: preconditionFailure()
            }
        }
        
        var dir: Vec2 {
            switch self {
            case .north: return Vec2(x: 0, y: 1)
            case .east: return Vec2(x: 1, y: 0)
            case .south: return Vec2(x: 0, y: -1)
            case .west: return Vec2(x: -1, y: 0)
            default: return Vec2.zero
            }
        }
        
        mutating func rotate(angle: Int) {
            let steps = (angle / 90) % 4
            
            if steps <= 0 {
                for _ in 0..<abs(steps) {
                    turnRight()
                }
            } else {
                for _ in 0..<(4 - steps) {
                    turnRight()
                }
            }
        }
        
        mutating func turnRight() {
            switch self {
            case .north(let value): self = .east(value)
            case .east(let value): self = .south(value)
            case .south(let value): self = .west(value)
            case .west(let value): self = .north(value)
            default: break
            }
        }
    }

    func testDay12_1() throws {
        
        let instructions = loadFile(name: "day12.txt")
            .split(separator: "\n")
            .map { Nav(key: String($0.prefix(1)), value: Int($0[$0.index(after: $0.startIndex)...])!)
        }
        
        var heading: Nav = .east(0)
        var position: Vec2 = .zero
        
        for i in instructions {
            switch i {
            case .north(let value):
                position += Vec2(x: 0, y: value)
            case .south(let value):
                position += Vec2(x: 0, y: -value)
            case .east(let value):
                position += Vec2(x: value, y: 0)
            case .west(let value):
                position += Vec2(x: -value, y: 0)
            case .left(let value):
                heading.rotate(angle: value)
            case .right(let value):
                heading.rotate(angle: -value)
            case .forward(let value):
                position += heading.dir * value
            }
        }
        
        XCTAssertEqual(abs(position.x) + abs(position.y), 415)
    }
    
    func testDay12_2() throws {
        
        let instructions = loadFile(name: "day12.txt")
            .split(separator: "\n")
            .map { Nav(key: String($0.prefix(1)), value: Int($0[$0.index(after: $0.startIndex)...])!)
        }
        
        var waypoint: Vec2 = Vec2(x: 10, y: 1)
        var position: Vec2 = .zero
        
        for i in instructions {
            switch i {
            case .north(let value):
                waypoint += Vec2(x: 0, y: value)
            case .south(let value):
                waypoint += Vec2(x: 0, y: -value)
            case .east(let value):
                waypoint += Vec2(x: value, y: 0)
            case .west(let value):
                waypoint += Vec2(x: -value, y: 0)
            case .left(let value):
                waypoint.rotate(angle: value)
            case .right(let value):
                waypoint.rotate(angle: -value)
            case .forward(let value):
                position += waypoint * value
            }
        }
        
        XCTAssertEqual(abs(position.x) + abs(position.y), 29401)
    }
}
