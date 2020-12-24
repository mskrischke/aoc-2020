//
//  Day24Tests.swift
//  aoc-2020Tests
//
//  Created by Markus Krischke on 24.12.20.
//

import XCTest

class Day24Tests: XCTestCase {
    
    enum Dir: String, CaseIterable {
        case east = "e"
        case southEast = "se"
        case southWest = "sw"
        case west = "w"
        case northWest = "nw"
        case northEast = "ne"
        
        var move: Vec3 {
            switch self {
                case .east:
                    return Vec3(x: 1, y: -1, z: 0)
                case .southEast:
                    return Vec3(x: 0, y: -1, z: 1)
                case .southWest:
                    return Vec3(x: -1, y: 0, z: 1)
                case .west:
                    return Vec3(x: -1, y: 1, z: 0)
                case .northWest:
                    return Vec3(x: 0, y: 1, z: -1)
                case .northEast:
                    return Vec3(x: 1, y: 0, z: -1)
            }
        }
    }
    
    enum Tile {
        case white, black
        
        mutating func flip() {
            self = self == .white ? .black : .white
        }
    }
    
    func testDay24_1() throws {
        var tiles: [Vec3: Tile] = [:]
        for directions in loadData() {
            var start = Vec3.zero
            
            for dir in directions {
                start += dir.move
            }
            tiles[start, default: .white].flip()
        }
        XCTAssertEqual(tiles.values.filter { $0 == .black }.count, 485)
    }
    
    func testDay24_2() throws {
        var tiles: [Vec3: Tile] = [:]
        var largestDim = 0
        for directions in loadData() {
            var start = Vec3.zero
            
            for dir in directions {
                start += dir.move
            }
            largestDim = start.max
            tiles[start, default: .white].flip()
        }
        
        for _ in 0..<100 {
            
            var cp = tiles
            largestDim = tiles.keys.map { $0.max }.max()! + 5
            
            for z in -largestDim...largestDim {
                for y in -largestDim...largestDim {
                    for x in -largestDim...largestDim {
                        
                        let pos = Vec3(x: x, y: y, z: z)
                        let adjacents = Dir.allCases.map { pos + $0.move }.map { tiles[$0] ?? .white }
                        let blacks = adjacents.filter { $0 == .black }.count
                        
                        let own = tiles[pos] ?? .white
                        if own == .white, blacks == 2 {
                            cp[pos] = .black
                        } else if own == .black, blacks == 0 || blacks > 2 {
                            cp[pos] = .white
                        }
                    }
                }
            }
            
            tiles = cp
        }
        XCTAssertEqual(tiles.values.filter { $0 == .black }.count, 3933)
    }
    
    private func loadData() -> [[Dir]] {
        let data = loadFile(name: "day24.txt")
        return data.components(separatedBy: "\n").filter { !$0.isEmpty }.map { Array(flips: $0) }
    }
}

extension Array where Element == Day24Tests.Dir {
    
    init(flips: String) {
        
        var tmp: Character?
        var dirs: [Day24Tests.Dir] = []
        
        for c in flips {
            if let previous = tmp, let dir = Day24Tests.Dir(rawValue: String(previous) + String(c)) {
                dirs.append(dir)
                tmp = nil
            } else if let dir = Day24Tests.Dir(rawValue: String(c)) {
                dirs.append(dir)
            } else {
                tmp = c
            }
        }
        
        self.init(dirs)
    }
}
