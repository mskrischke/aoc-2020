//
//  Day17Tests.swift
//  aoc-2020Tests
//
//  Created by Markus Krischke on 17.12.20.
//

import XCTest

class Day17Tests: XCTestCase {
    
    typealias Cube = [[[CubeValue]]]
    typealias HyperCube = [[[[CubeValue]]]]
    
    enum CubeValue: String {
        case active = "#"
        case inactive = "."
    }
    
    struct HyperDimension {
        var cube: HyperCube
        let dim: Int
        
        init(cube: HyperCube) {
            self.cube = cube
            self.dim = cube.count
        }
        
        var activeCount: Int {
            var active = 0
            for w in 0..<dim {
                for z in 0..<dim {
                    for y in 0..<dim {
                        for x in 0..<dim {
                            let pos = Vec4(x: x, y: y, z: z, w: w)
                            if self[pos] == .active {
                                active += 1
                            }
                        }
                    }
                }
            }
            return active
        }
        
        func adjacentValues(for center: Vec4) -> [CubeValue] {
            return center.surrounding.map { return self[$0] }
        }
        
        subscript(pos: Vec4) -> CubeValue {
            get {
                guard pos.w >= 0 && pos.w < dim && pos.z >= 0 && pos.z < dim && pos.y >= 0 && pos.y < dim && pos.x >= 0 && pos.x < dim else {
                    return .inactive
                }
                return cube[pos.w][pos.z][pos.y][pos.x]
            }
            set {
                cube[pos.w][pos.z][pos.y][pos.x] = newValue
            }
        }
    }
    
    struct Dimension {
        var cube: Cube
        let dim: Int
        
        init(cube: Cube) {
            self.cube = cube
            self.dim = cube.count
        }
        
        var activeCount: Int {
            var active = 0
            for z in 0..<dim {
                for y in 0..<dim {
                    for x in 0..<dim {
                        let pos = Vec3(x: x, y: y, z: z)
                        if self[pos] == .active {
                            active += 1
                        }
                    }
                }
            }
            return active
        }
        
        func adjacentValues(for center: Vec3) -> [CubeValue] {
            return center.surrounding.map { return self[$0] }
        }
        
        subscript(pos: Vec3) -> CubeValue {
            get {
                guard pos.z >= 0 && pos.z < dim && pos.y >= 0 && pos.y < dim && pos.x >= 0 && pos.x < dim else {
                    return .inactive
                }
                return cube[pos.z][pos.y][pos.x]
            }
            set {
                cube[pos.z][pos.y][pos.x] = newValue
            }
        }
    }
    
    struct Vec3 {
        static let zero = Vec3(x: 0, y: 0, z: 0)
        var x, y, z: Int
        
        var surrounding: [Vec3] {
            return [
                (x-1,y-1,z),(x,y-1,z),(x+1,y-1,z),(x-1,y,z),(x+1,y,z),(x-1,y+1,z),(x,y+1,z),(x+1,y+1,z),
                (x-1,y-1,z-1),(x,y-1,z-1),(x+1,y-1,z-1),(x-1,y,z-1),(x,y,z-1),(x+1,y,z-1),(x-1,y+1,z-1),(x,y+1,z-1),(x+1,y+1,z-1),
                (x-1,y-1,z+1),(x,y-1,z+1),(x+1,y-1,z+1),(x-1,y,z+1),(x,y,z+1),(x+1,y,z+1),(x-1,y+1,z+1),(x,y+1,z+1),(x+1,y+1,z+1)
                
            ].map { Vec3(x: $0.0, y: $0.1, z: $0.2) }
        }
    }
    
    struct Vec4 {
        static let zero = Vec4(x: 0, y: 0, z: 0, w:0)
        var x, y, z, w: Int
        
        var surrounding: [Vec4] {
            return [
                (x-1,y-1,z,w-1),(x,y-1,z,w-1),(x+1,y-1,z,w-1),(x-1,y,z,w-1),(x,y,z,w-1),(x+1,y,z,w-1),(x-1,y+1,z,w-1),(x,y+1,z,w-1),(x+1,y+1,z,w-1),
                (x-1,y-1,z-1,w-1),(x,y-1,z-1,w-1),(x+1,y-1,z-1,w-1),(x-1,y,z-1,w-1),(x,y,z-1,w-1),(x+1,y,z-1,w-1),(x-1,y+1,z-1,w-1),(x,y+1,z-1,w-1),(x+1,y+1,z-1,w-1),
                (x-1,y-1,z+1,w-1),(x,y-1,z+1,w-1),(x+1,y-1,z+1,w-1),(x-1,y,z+1,w-1),(x,y,z+1,w-1),(x+1,y,z+1,w-1),(x-1,y+1,z+1,w-1),(x,y+1,z+1,w-1),(x+1,y+1,z+1,w-1),
                ///
                (x-1,y-1,z,w),(x,y-1,z,w),(x+1,y-1,z,w),(x-1,y,z,w),(x+1,y,z,w),(x-1,y+1,z,w),(x,y+1,z,w),(x+1,y+1,z,w),
                (x-1,y-1,z-1,w),(x,y-1,z-1,w),(x+1,y-1,z-1,w),(x-1,y,z-1,w),(x,y,z-1,w),(x+1,y,z-1,w),(x-1,y+1,z-1,w),(x,y+1,z-1,w),(x+1,y+1,z-1,w),
                (x-1,y-1,z+1,w),(x,y-1,z+1,w),(x+1,y-1,z+1,w),(x-1,y,z+1,w),(x,y,z+1,w),(x+1,y,z+1,w),(x-1,y+1,z+1,w),(x,y+1,z+1,w),(x+1,y+1,z+1,w),
                ///
                (x-1,y-1,z,w+1),(x,y-1,z,w+1),(x+1,y-1,z,w+1),(x-1,y,z,w+1),(x,y,z,w+1),(x+1,y,z,w+1),(x-1,y+1,z,w+1),(x,y+1,z,w+1),(x+1,y+1,z,w+1),
                (x-1,y-1,z-1,w+1),(x,y-1,z-1,w+1),(x+1,y-1,z-1,w+1),(x-1,y,z-1,w+1),(x,y,z-1,w+1),(x+1,y,z-1,w+1),(x-1,y+1,z-1,w+1),(x,y+1,z-1,w+1),(x+1,y+1,z-1,w+1),
                (x-1,y-1,z+1,w+1),(x,y-1,z+1,w+1),(x+1,y-1,z+1,w+1),(x-1,y,z+1,w+1),(x,y,z+1,w+1),(x+1,y,z+1,w+1),(x-1,y+1,z+1,w+1),(x,y+1,z+1,w+1),(x+1,y+1,z+1,w+1)
                
            ].map { Vec4(x: $0.0, y: $0.1, z: $0.2, w: $0.3) }
        }
    }

    func testDay17_1() throws {
        var dimension = loadData(space: 50)
        for _ in 0..<6 {
            dimension = cycle(input: dimension)
        }
        XCTAssertEqual(dimension.activeCount, 295)
    }
    
    func testDay17_2() throws {
        var dimension = loadHyperData(space: 40)
        for _ in 0..<6 {
            dimension = hyperCycle(input: dimension)
        }
        XCTAssertEqual(dimension.activeCount, 1972)
    }
    
    private func cycle(input: Dimension) -> Dimension {
        var output = input
        
        for z in 0..<input.dim {
            for y in 0..<input.dim {
                for x in 0..<input.dim {
                    let pos = Vec3(x: x, y: y, z: z)
                    let adjacent = input.adjacentValues(for: pos)
                    let activeNeighbors = adjacent.filter { $0 == .active }.count
                    
                    if input[pos] == .active {
                        if activeNeighbors != 2 && activeNeighbors != 3 {
                            output[pos] = .inactive
                        }
                    } else {
                        if activeNeighbors == 3 {
                            output[pos] = .active
                        }
                    }
                }
            }
        }
        return output
    }
    
    private func hyperCycle(input: HyperDimension) -> HyperDimension {
        var output = input
        
        for w in 0..<input.dim {
            for z in 0..<input.dim {
                for y in 0..<input.dim {
                    for x in 0..<input.dim {
                        let pos = Vec4(x: x, y: y, z: z, w: w)
                        let adjacent = input.adjacentValues(for: pos)
                        let activeNeighbors = adjacent.filter { $0 == .active }.count
                        
                        if input[pos] == .active {
                            if activeNeighbors != 2 && activeNeighbors != 3 {
                                output[pos] = .inactive
                            }
                        } else {
                            if activeNeighbors == 3 {
                                output[pos] = .active
                            }
                        }
                    }
                }
            }
        }
        return output
    }
    
    private func loadData(space: Int = 16) -> Dimension {
        let input = loadFile(name: "day17.txt")
        
        /// z, y, x
        var cube: Cube = []
        for _ in 0..<space {
            var yLayer: [[CubeValue]] = []
            for _ in 0..<space {
                for _ in 0..<space {
                    yLayer.append(Array(repeating: CubeValue.inactive, count: space))
                }
            }
            cube.append(yLayer)
        }
        
        let center = space / 2
        
        for (row, line) in input.split(separator: "\n").enumerated() {
            for (column, value) in line.enumerated() {
                cube[center][center + row][center + column] = CubeValue(rawValue: String(value))!
            }
        }
        return Dimension(cube: cube)
    }
    
    private func loadHyperData(space: Int) -> HyperDimension {
        let input = loadFile(name: "day17.txt")
        
        /// w, z, y, x
        var cube: HyperCube = []
        for _ in 0..<space {
            var zLayer: Cube = []
            for _ in 0..<space {
                var yLayer: [[CubeValue]] = []
                for _ in 0..<space {
                    for _ in 0..<space {
                        yLayer.append(Array(repeating: CubeValue.inactive, count: space))
                    }
                }
                zLayer.append(yLayer)
            }
            cube.append(zLayer)
        }
        
        let center = space / 2
        
        for (row, line) in input.split(separator: "\n").enumerated() {
            for (column, value) in line.enumerated() {
                cube[center][center][center + row][center + column] = CubeValue(rawValue: String(value))!
            }
        }
        return HyperDimension(cube: cube)
    }
}
