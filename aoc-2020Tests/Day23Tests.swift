//
//  Day23Tests.swift
//  aoc-2020Tests
//
//  Created by Markus Krischke on 23.12.20.
//

import XCTest

class Day23Tests: XCTestCase {

    func testDay23_1() throws {
        
        func extractResult(_ cups: [Int]) -> String {
            return (cups[cups.firstIndex(of: 1)!...] + cups[..<cups.firstIndex(of: 1)!]).dropFirst().map { String($0) }.joined()
        }
        
        let testCups = [3,8,9,1,2,5,4,6,7]
        XCTAssertEqual(extractResult(play(allCups: testCups, iterations: 10)), "92658374")
        XCTAssertEqual(extractResult(play(allCups: testCups, iterations: 100)), "67384529")
        
        let myCups = [3,9,4,6,1,8,5,2,7]
        XCTAssertEqual(extractResult(play(allCups: myCups, iterations: 100)), "78569234")
    }
    
    func testDay23_2() throws {
        let testCups = [3,8,9,1,2,5,4,6,7] + (10...1_000_000).map { $0 }
        XCTAssertEqual(play2(allCups: testCups, iterations: 10_000_000), 149245887792)
        
        let myCups = [3,9,4,6,1,8,5,2,7] + (10...1_000_000).map { $0 }
        XCTAssertEqual(play2(allCups: myCups, iterations: 10_000_000), 565615814504)
    }
    
    private func play(allCups: [Int], iterations: Int) -> [Int] {
        var cups = allCups
        var indexOfCurrentCup = 0
        var currentCup = allCups[indexOfCurrentCup]
        
        for _ in 0..<iterations {
//            print("cups: \(cups.map { $0 == currentCup ? "(\($0))" : "\($0)" }.joined(separator: " "))")
            
            var takenOut: [Int] = []
            takenOut.append(cups[(indexOfCurrentCup+1) % cups.count])
            takenOut.append(cups[(indexOfCurrentCup+2) % cups.count])
            takenOut.append(cups[(indexOfCurrentCup+3) % cups.count])
            cups.removeAll(where: { takenOut.contains($0) })
            
//            print("pickup: \(Array(takenOut))")
            
            var destinationCup = currentCup - 1
            while !cups.contains(destinationCup) {
                destinationCup -= 1
                
                if !allCups.contains(destinationCup) {
                    destinationCup = allCups.sorted().last!
                }
            }
            
//            print("destination: \(destinationCup)")
            
            let indexOfDestination = cups.firstIndex(of: destinationCup)!
            cups.insert(contentsOf: takenOut, at: (indexOfDestination + 1) % cups.count)
            
            indexOfCurrentCup = cups.firstIndex(of: currentCup)!
            indexOfCurrentCup = ((indexOfCurrentCup + 1) % cups.count)
            currentCup = cups[indexOfCurrentCup]
        }
        
//        print("cups: \(cups.map { $0 == currentCup ? "(\($0))" : "\($0)" }.joined(separator: " "))")
        
        return cups
    }
    
    private func play2(allCups: [Int], iterations: Int) -> Int {
        
        func removeCup(after: Int) -> Int {
            let toRemove = nextCupLookup[after]
            let newNext = nextCupLookup[toRemove]
            nextCupLookup[after] = newNext
            return toRemove
        }
        
        var nextCupLookup = Array(repeating: 0, count: allCups.count + 2)
        for (index, cup) in allCups.enumerated() {
            nextCupLookup[cup] = allCups[(index + 1) % allCups.count]
        }
        
        var currentCup = allCups[0]
        
        for _ in 0..<iterations {
            let takenOut = [removeCup(after: currentCup), removeCup(after: currentCup), removeCup(after: currentCup)]
            
            // find next destination
            var destinationCup = currentCup - 1
            while takenOut.contains(destinationCup) || destinationCup < 1 {
                destinationCup -= 1
                
                if destinationCup <= 0 {
                    destinationCup = allCups.count
                }
            }
            
            // reinsert
            takenOut.reversed().forEach { newCup in
                let previousNext = nextCupLookup[destinationCup]
                nextCupLookup[destinationCup] = newCup
                nextCupLookup[newCup] = previousNext
            }

            currentCup = nextCupLookup[currentCup]
        }
        
        let z = nextCupLookup[1]
        let y = nextCupLookup[z]
        return z * y
    }
}
