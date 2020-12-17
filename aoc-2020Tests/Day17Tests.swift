//
//  Day17Tests.swift
//  aoc-2020Tests
//
//  Created by Markus Krischke on 17.12.20.
//

import XCTest

class Day17Tests: XCTestCase {
    
    typealias HyperCube = [[[[CubeValue]]]]
    
    enum CubeValue: String {
        case active = "#"
        case inactive = "."
    }
    
    struct Dimension {
        var cube: HyperCube
        let dim: Int
        let hyperDim: Int
        
        init(cube: HyperCube) {
            self.cube = cube
            self.dim = cube[0].count
            self.hyperDim = cube.count
        }
        
        var activeCount: Int {
            var active = 0
            for w in 0..<hyperDim {
                for z in 0..<dim {
                    for y in 0..<dim {
                        for x in 0..<dim {
                            if cube[w][z][y][x] == .active {
                                active += 1
                            }
                        }
                    }
                }
            }
            return active
        }
        
        func adjacentValues(x: Int, y: Int, z: Int, w: Int) -> Int {
            
            var v = [
                cube[w][z+1][y+1][x+1],
                cube[w][z+1][y+1][x],
                cube[w][z+1][y+1][x-1],
                cube[w][z+1][y][x+1],
                cube[w][z+1][y][x],
                cube[w][z+1][y][x-1],
                cube[w][z+1][y-1][x+1],
                cube[w][z+1][y-1][x],
                cube[w][z+1][y-1][x-1],
                cube[w][z][y+1][x+1],
                cube[w][z][y+1][x],
                cube[w][z][y+1][x-1],
                cube[w][z][y][x+1],
                //cube[w][z][y][x],
                cube[w][z][y][x-1],
                cube[w][z][y-1][x+1],
                cube[w][z][y-1][x],
                cube[w][z][y-1][x-1],
                cube[w][z-1][y+1][x+1],
                cube[w][z-1][y+1][x],
                cube[w][z-1][y+1][x-1],
                cube[w][z-1][y][x+1],
                cube[w][z-1][y][x],
                cube[w][z-1][y][x-1],
                cube[w][z-1][y-1][x+1],
                cube[w][z-1][y-1][x],
                cube[w][z-1][y-1][x-1],
            ]

            if hyperDim > 1 {
                v += [
                    cube[w+1][z+1][y+1][x+1],
                    cube[w+1][z+1][y+1][x],
                    cube[w+1][z+1][y+1][x-1],
                    cube[w+1][z+1][y][x+1],
                    cube[w+1][z+1][y][x],
                    cube[w+1][z+1][y][x-1],
                    cube[w+1][z+1][y-1][x+1],
                    cube[w+1][z+1][y-1][x],
                    cube[w+1][z+1][y-1][x-1],
                    cube[w+1][z][y+1][x+1],
                    cube[w+1][z][y+1][x],
                    cube[w+1][z][y+1][x-1],
                    cube[w+1][z][y][x+1],
                    cube[w+1][z][y][x],
                    cube[w+1][z][y][x-1],
                    cube[w+1][z][y-1][x+1],
                    cube[w+1][z][y-1][x],
                    cube[w+1][z][y-1][x-1],
                    cube[w+1][z-1][y+1][x+1],
                    cube[w+1][z-1][y+1][x],
                    cube[w+1][z-1][y+1][x-1],
                    cube[w+1][z-1][y][x+1],
                    cube[w+1][z-1][y][x],
                    cube[w+1][z-1][y][x-1],
                    cube[w+1][z-1][y-1][x+1],
                    cube[w+1][z-1][y-1][x],
                    cube[w+1][z-1][y-1][x-1],
                    cube[w-1][z+1][y+1][x+1],
                    cube[w-1][z+1][y+1][x],
                    cube[w-1][z+1][y+1][x-1],
                    cube[w-1][z+1][y][x+1],
                    cube[w-1][z+1][y][x],
                    cube[w-1][z+1][y][x-1],
                    cube[w-1][z+1][y-1][x+1],
                    cube[w-1][z+1][y-1][x],
                    cube[w-1][z+1][y-1][x-1],
                    cube[w-1][z][y+1][x+1],
                    cube[w-1][z][y+1][x],
                    cube[w-1][z][y+1][x-1],
                    cube[w-1][z][y][x+1],
                    cube[w-1][z][y][x],
                    cube[w-1][z][y][x-1],
                    cube[w-1][z][y-1][x+1],
                    cube[w-1][z][y-1][x],
                    cube[w-1][z][y-1][x-1],
                    cube[w-1][z-1][y+1][x+1],
                    cube[w-1][z-1][y+1][x],
                    cube[w-1][z-1][y+1][x-1],
                    cube[w-1][z-1][y][x+1],
                    cube[w-1][z-1][y][x],
                    cube[w-1][z-1][y][x-1],
                    cube[w-1][z-1][y-1][x+1],
                    cube[w-1][z-1][y-1][x],
                    cube[w-1][z-1][y-1][x-1],
                ]
            }
            return v.filter { $0 == .active }.count
        }
    }

    func testDay17_1() throws {
        var dimension = loadHyperData(space: 40, hyper: 1)
        for _ in 0..<6 {
            dimension = hyperCycle(input: dimension)
        }
        XCTAssertEqual(dimension.activeCount, 295)
    }
    
    func testDay17_2() throws {
        var dimension = loadHyperData(space: 30, hyper: 30)
        for _ in 0..<6 {
            dimension = hyperCycle(input: dimension)
        }
        XCTAssertEqual(dimension.activeCount, 1972)
    }
    
    private func hyperCycle(input: Dimension) -> Dimension {
        var output = input
        
        let s = 1
        
        if input.hyperDim == 1 {
            for z in s..<input.dim - 1 {
                for y in s..<input.dim - 1 {
                    for x in s..<input.dim - 1 {
                        let activeNeighbors = input.adjacentValues(x: x, y: y, z: z, w: 0)
                        
                        if input.cube[0][z][y][x] == .active {
                            if activeNeighbors != 2 && activeNeighbors != 3 {
                                output.cube[0][z][y][x] = .inactive
                            }
                        } else {
                            if activeNeighbors == 3 {
                                output.cube[0][z][y][x] = .active
                            }
                        }
                    }
                }
            }
        } else {
            for w in s..<input.hyperDim - 1 {
                for z in s..<input.dim - 1 {
                    for y in s..<input.dim - 1 {
                        for x in s..<input.dim - 1 {
                            let activeNeighbors = input.adjacentValues(x: x, y: y, z: z, w: w)
                            
                            if input.cube[w][z][y][x] == .active {
                                if activeNeighbors != 2 && activeNeighbors != 3 {
                                    output.cube[w][z][y][x] = .inactive
                                }
                            } else {
                                if activeNeighbors == 3 {
                                    output.cube[w][z][y][x] = .active
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return output
    }
    
    private func loadHyperData(space: Int, hyper: Int) -> Dimension {
        let input = loadFile(name: "day17.txt")
        
        /// w, z, y, x
        var cube: HyperCube = []
        for _ in 0..<hyper {
            var zLayer: [[[CubeValue]]] = []
            for _ in 0..<space {
                var yLayer: [[CubeValue]] = []
                for _ in 0..<space {
                    yLayer.append(Array(repeating: CubeValue.inactive, count: space))
                }
                zLayer.append(yLayer)
            }
            cube.append(zLayer)
        }
        
        let center = space / 2
        let hyperCenter = hyper > 1 ? center : 0
        
        for (row, line) in input.split(separator: "\n").enumerated() {
            for (column, value) in line.enumerated() {
                cube[hyperCenter][center][center + row][center + column] = CubeValue(rawValue: String(value))!
            }
        }
        return Dimension(cube: cube)
    }
}
