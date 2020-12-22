//
//  Day22Tests.swift
//  aoc-2020Tests
//
//  Created by Markus Krischke on 22.12.20.
//

import XCTest

class Day22Tests: XCTestCase {

    func testDay22_1() throws {
        var cards = loadData()
        
        while !(cards.player1.isEmpty || cards.player2.isEmpty) {
            let card1 = cards.player1.removeFirst()
            let card2 = cards.player2.removeFirst()
            
            if card1 > card2 {
                cards.player1.append(contentsOf: [card1, card2])
            } else {
                cards.player2.append(contentsOf: [card2, card1])
            }
        }
        
        print("Player1: \(cards.player1)")
        print("Player2: \(cards.player2)")
        XCTAssertEqual(countResult(cards), 32033)
    }
    
    func testDay22_2() throws {
        let input = loadData()
        let cards = play(player1: input.player1, player2: input.player2)
        
        print("Player1: \(cards.player1)")
        print("Player2: \(cards.player2)")
        XCTAssertEqual(countResult(cards), 34901)
    }

    private func countResult(_ cards: (player1: [Int], player2: [Int])) -> Int {
        let result: Int
        if !cards.player1.isEmpty {
            result = zip(cards.player1.reversed(), 1...cards.player1.count).map { $0.0 * $0.1 }.reduce(0, +)
        } else {
            result = zip(cards.player2.reversed(), 1...cards.player2.count).map { $0.0 * $0.1 }.reduce(0, +)
        }
        return result
    }
    
    private func play(player1 p1: [Int], player2 p2: [Int]) -> (player1: [Int], player2: [Int]) {
        
        var cards = (player1: p1, player2: p2)
        var previousHands: [([Int],[Int])] = []
        
        while !(cards.player1.isEmpty || cards.player2.isEmpty) {
            
            guard !previousHands.contains(where: { $0.0 == cards.player1 && $0.1 == cards.player2 }) else {
                return (p1, [])
            }
            previousHands.append(cards)
            
            let card1 = cards.player1.removeFirst()
            let card2 = cards.player2.removeFirst()
            
            if card1 <= cards.player1.count && card2 <= cards.player2.count {
                // new subgame
                if !play(player1: Array(cards.player1[0..<card1]), player2: Array(cards.player2[0..<card2])).player1.isEmpty {
                    // player1 won
                    cards.player1.append(contentsOf: [card1, card2])
                } else {
                    // player2 won
                    cards.player2.append(contentsOf: [card2, card1])
                }
            } else {
                // winner is with higher card
                if card1 > card2 {
                    cards.player1.append(contentsOf: [card1, card2])
                } else {
                    cards.player2.append(contentsOf: [card2, card1])
                }
            }
        }
        return cards
    }
    
    private func loadData() -> (player1: [Int], player2: [Int]) {
        let r = loadFile(name: "day22.txt").components(separatedBy: "\n\n").map { $0.components(separatedBy: "\n").filter { !$0.isEmpty }.dropFirst() }.map { $0.map { Int($0)! } }
        return (r[0], r[1])
    }
}
