//
//  Day20Tests.swift
//  aoc-2020Tests
//
//  Created by Markus Krischke on 20.12.20.
//

import XCTest

class Day20Tests: XCTestCase {

    struct Tile: Identifiable, CustomDebugStringConvertible {

        var debugDescription: String {
            return data.map { String($0) }.joined(separator: "\n")
        }

        func debug() {
            print(debugDescription)
        }

        let id: Int
        var data: [[Character]] = []

        var leftBorder: String {
            return String(data.map { $0[0] })
        }

        var rightBorder: String {
            return String(data.map { $0[9] })
        }

        var topBorder: String {
            return String(data[0])
        }

        var bottomBorder: String {
            return String(data[9])
        }

        var allSides: Set<String> {
            return [leftBorder, rightBorder, bottomBorder, topBorder, String(leftBorder.reversed()), String(rightBorder.reversed()), String(bottomBorder.reversed()), String(topBorder.reversed())]
        }

        func flipHorizontal() -> Tile {
            var newData: [[Character]] = []
            for e in data {
               newData.append(e.reversed())
            }
            return Tile(id: id, data: newData)
        }

        func flipVertical() -> Tile {
            return Tile(id: id, data: data.reversed())
        }

        func rotatedLeft() -> Tile {
            let d = data.reduce(into: [[Character]](repeating: [Character](), count: data.count)) {
                (arr, row) in
                for (i,x) in row.reversed().enumerated() {
                    arr[i].append(x)
                }
            }
            return Tile(id: id, data: d)
        }

        func rotatedRight() -> Tile {
            let d = data.reduce(into: [[Character]](repeating: [Character](), count: data.count)) {
                (arr, row) in
                for (i,x) in row.enumerated() {
                    arr[i].insert(x, at: 0)
                }
            }
            return Tile(id: id, data: d)
        }
    }

    func testDay20_1() throws {
        let data = loadData()
        let corners = findCorners(tiles: data)
        XCTAssertEqual(corners.count, 4)
        XCTAssertEqual(corners.map { $0.id }.reduce(1, *), 18411576553343)
    }

    func testDay20_2() throws {
        var data = loadData()
        let corners = findCorners(tiles: data)

        let elementCount = corners[0].data.count
        let sideLength = Int(sqrt(Double(data.count)))
        var grid: [[Tile?]] = Array(repeating: Array(repeating: Optional<Tile>.none, count: sideLength), count: sideLength)

        for r in 0..<sideLength {
            for c in 0..<sideLength {

                let tile: Tile
                if r==0 && c==0 {
                    tile = corners.first!.rotatedLeft()
                } else if c > 0 {
                    let previousTile = grid[r][c - 1]!.rightBorder
                    let matchingTile = data.first(where: { $0.allSides.contains(previousTile) })!

                    switch previousTile {
                    case matchingTile.leftBorder:
                        tile = matchingTile
                    case matchingTile.rightBorder:
                        tile = matchingTile.flipHorizontal()
                    case matchingTile.topBorder:
                        tile = matchingTile.rotatedLeft().flipVertical()
                    case matchingTile.bottomBorder:
                        tile = matchingTile.rotatedRight()
                    case String(matchingTile.leftBorder.reversed()):
                        tile = matchingTile.flipVertical()
                    case String(matchingTile.rightBorder.reversed()):
                        tile = matchingTile.flipVertical().flipHorizontal()
                    case String(matchingTile.topBorder.reversed()):
                        tile = matchingTile.rotatedLeft()
                    case String(matchingTile.bottomBorder.reversed()):
                        tile = matchingTile.rotatedRight().flipVertical()
                    default: preconditionFailure()
                    }
                } else {
                    let previousTile = grid[r-1][c]!.bottomBorder
                    let matchingTile = data.first(where: { $0.allSides.contains(previousTile) })!

                    switch previousTile {
                    case matchingTile.leftBorder:
                        tile = matchingTile.rotatedRight().flipHorizontal()
                    case matchingTile.rightBorder:
                        tile = matchingTile.rotatedLeft()
                    case matchingTile.topBorder:
                        tile = matchingTile
                    case matchingTile.bottomBorder:
                        tile = matchingTile.flipVertical()
                    case String(matchingTile.leftBorder.reversed()):
                        tile = matchingTile.rotatedRight()
                    case String(matchingTile.rightBorder.reversed()):
                        tile = matchingTile.rotatedLeft().flipHorizontal()
                    case String(matchingTile.topBorder.reversed()):
                        tile = matchingTile.flipHorizontal()
                    case String(matchingTile.bottomBorder.reversed()):
                        tile = matchingTile.flipVertical().flipHorizontal()
                    default: preconditionFailure()
                    }
                }

                data.remove(at: data.firstIndex(where: { $0.id == tile.id })!)
                grid[r][c] = tile

//                for index in 0..<grid.count * elementCount {
//                    let row = index / elementCount
//                    let innerRow = index % elementCount
//                    print(String(grid[row].map { $0?.data[innerRow] ?? Array(repeating: "X", count: elementCount) }.joined(separator: " ")))
//                }
            }
        }
        XCTAssertEqual(grid[0][0]!.id * grid[0][grid.count-1]!.id * grid[grid.count-1][0]!.id * grid[grid.count-1][grid.count-1]!.id, 18411576553343)

        /// Strip grid borders
        var totalData: [[Character]] = []
        for index in 0..<grid.count * elementCount {
            let row = index / elementCount
            let innerRow = index % elementCount

            if innerRow == 0 || innerRow == elementCount - 1 {
                continue
            }

            let z = grid[row].flatMap { $0!.data[innerRow].dropFirst().dropLast() }
            totalData.append(z)
        }

        var completeMap = Tile(id: 1, data: totalData).flipVertical()
        completeMap.debug()

        let seamonsterPattern = [(0,0),(5,0),(6,0),(11,0),(12,0),(17,0),(18,0),(19,0),(18,-1),(1,1),(4,1),(7,1),(10,1),(13,1),(16,1)]
        for (rowIndex, row) in completeMap.data.enumerated() {
            guard rowIndex > 0 && rowIndex < completeMap.data.count - 1 else { continue }

            for (colIndex, _) in row.enumerated() {
                guard colIndex < row.count - 19 else { continue }

                let patterns = seamonsterPattern.map { completeMap.data[rowIndex + $0.1][colIndex + $0.0] }
                if patterns.allSatisfy({ $0 == "#" }) {
                    print("Found a sea monster at \(rowIndex),\(colIndex)")
                    seamonsterPattern.forEach { completeMap.data[rowIndex + $0.1][colIndex + $0.0] = "O" }
                }
            }
        }

        print("----------------")
        completeMap.debug()

        let habitat = completeMap.data.flatMap { $0 }.filter { $0 == "#" }.count
        XCTAssertEqual(habitat, 2002)
    }

    private func findCorners(tiles data: [Tile]) -> [Tile] {
        var corners: [Tile] = []
        for (index, tile) in data.enumerated() {

            var otherTiles = data
            otherTiles.remove(at: index)

            var adjacentTiles: [Tile] = []
            for otherTile in otherTiles {
                let commonSides = tile.allSides.intersection(otherTile.allSides)

                if !commonSides.isEmpty {
                    adjacentTiles.append(otherTile)
                }
            }

            if adjacentTiles.count == 2 {
                corners.append(tile)
            }
        }

        return corners
    }

    private func loadData() -> [Tile] {
        return loadFile(name: "day20_1.txt").components(separatedBy: "\n\n").map {
            var lines = $0.components(separatedBy: "\n").filter { !$0.isEmpty }
            let id = Int(lines.removeFirst().replacingOccurrences(of: "Tile ", with: "").replacingOccurrences(of: ":", with: ""))!
            return Tile(id: id, data: lines.map { Array($0) })
        }
    }
}
