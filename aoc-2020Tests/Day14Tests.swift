//
//  Day14Tests.swift
//  aoc-2020Tests
//
//  Created by Markus Krischke on 14.12.20.
//

import XCTest

class Day14Tests: XCTestCase {
    
    struct Instruction {
        var mask: String
        var mems: [String] = []
        var vals: [Int] = []
    }

    func testDay14_1() throws {
        var memory: [String: Int] = [:]
        let instructions = loadInstructions()
        
        for instruction in instructions {
            let mask = instruction.mask
            for (index, address) in instruction.mems.enumerated() {
                let value = instruction.vals[index]
                let binaryRepresentation = String(value, radix: 2).padLeft(toSize: 36, with: "0")
                let maskedValue = String(zip(mask, binaryRepresentation).map { $0.0 == "X" ? $0.1 : $0.0 })
                memory[address] = Int(maskedValue, radix: 2)!
            }
        }
        
        XCTAssertEqual(memory.values.reduce(0, +), 15514035145260)
    }
    
    func testDay14_2() throws {
        var memory: [String: Int] = [:]
        let instructions = loadInstructions()
        
        for instruction in instructions {
            let mask = instruction.mask
            for (index, mem) in instruction.mems.enumerated() {
                let address = Int(mem.replacingOccurrences(of: "mem[", with: "").replacingOccurrences(of: "]", with: ""))!
                let binaryRepresentation = String(address, radix: 2).padLeft(toSize: 36, with: "0")
                let maskedAddress = String(zip(mask, binaryRepresentation).map { $0.0 == "0" ? $0.1 : $0.0 })
                
                let floatingAddresses = permutate(maskedAddress)
                for floatingAddress in floatingAddresses {
                    memory[floatingAddress] = instruction.vals[index]
                }
            }
        }
        
        XCTAssertEqual(memory.values.reduce(0, +), 3926790061594)
    }
    
    private func permutate(_ address: String) -> [String] {
        var sequence = Array(address)
        guard let index = sequence.firstIndex(of: "X") else {
            return [address]
        }
        
        var results: [String] = []
        
        sequence[index] = Character("0")
        results.append(contentsOf: permutate(String(sequence)))
        
        sequence[index] = Character("1")
        results.append(contentsOf: permutate(String(sequence)))
        
        return results
    }

    private func loadInstructions() -> [Instruction] {
        var instructions: [Instruction] = []
        var currentInstruction: Instruction?
        
        for line in loadFile(name: "day14.txt").split(separator: "\n") {
            let parts = line.components(separatedBy: " = ")
            guard parts.count == 2 else { continue }
            
            if parts[0].starts(with: "mask") {
                if let instruction = currentInstruction {
                    instructions.append(instruction)
                }
                currentInstruction = Instruction(mask: String(parts[1]))
            } else if parts[0].starts(with: "mem") {
                currentInstruction?.mems.append(parts[0])
                currentInstruction?.vals.append(Int(parts[1])!)
            }
        }
        
        if let instruction = currentInstruction {
            instructions.append(instruction)
        }
        return instructions
    }
}
