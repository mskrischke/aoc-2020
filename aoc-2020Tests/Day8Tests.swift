//
//  Day8Tests.swift
//  aoc-2020Tests
//
//  Created by Markus Krischke on 08.12.20.
//

import XCTest

class Console {

    enum Instruction {
        case nop(Int), acc(Int), jmp(Int)

        init?(rawValue: String) {
            guard let value = rawValue.components(separatedBy: " ").last,
                  let param = Int(value) else {
                return nil
            }

            switch rawValue {
            case let v where v.prefix(3) == "nop":
                self = .nop(param)
            case let v where v.prefix(3) == "jmp":
                self = .jmp(param)
            case let v where v.prefix(3) == "acc":
                self = .acc(param)
            default:
                preconditionFailure()
            }
        }
    }

    private var pointer = 0
    private var instructions: [Instruction] = []
    private(set) var accumulator: Int = 0

    var continueRunning: (Int) -> Bool = { _ in true }
    var finished: (Int) -> Void = { _ in }

    func load(data: String) {
        instructions = data.components(separatedBy: "\n").filter { !$0.isEmpty }.compactMap(Instruction.init)
    }

    func load(_ instructions: [Instruction]) {
        self.instructions = instructions
    }

    func run() {
        pointer = 0
        accumulator = 0

        while continueRunning(pointer) {
            switch instructions[pointer] {
            case .nop:
                pointer += 1
            case .acc(let value):
                accumulator += value
                pointer += 1
            case .jmp(let offset):
                pointer += offset
            }

            if pointer >= instructions.count {
                finished(accumulator)
                return
            }
        }
    }
}

class Day8Tests: XCTestCase {

    func testDay8_1() throws {
        let console = Console()
        console.load(data: loadFile(name: "day8.txt"))

        let exp = expectation(description: "Console first run")
        var pointers: [Int] = []
        console.continueRunning = { pointer in
            if pointers.contains(pointer) {
                exp.fulfill()
                return false
            } else {
                pointers.append(pointer)
                return true
            }
        }
        console.run()

        waitForExpectations(timeout: 30) { _ in
            XCTAssertEqual(console.accumulator, 2058)
        }
    }

    func testDay8_2() throws {
        let exp = expectation(description: "Console second run")

        let instructions = loadFile(name: "day8.txt")
            .components(separatedBy: "\n")
            .filter { !$0.isEmpty }
            .compactMap(Console.Instruction.init)

        let console = Console()

        console.finished = { (acc: Int) -> Void in
            XCTAssertEqual(acc, 1000)
            exp.fulfill()
        }

        var executedPointers: [Int] = []
        console.continueRunning = { pointer in
            if executedPointers.contains(pointer) {
                return false
            } else {
                executedPointers.append(pointer)
                return true
            }
        }

        for (index, instruction) in instructions.enumerated() {
            executedPointers = []

            var newInstructions = instructions
            if case let .jmp(val) = instruction {
                newInstructions[index] = .nop(val)
            } else if case let .nop(val) = instruction {
                newInstructions[index] = .jmp(val)
            } else {
                continue
            }
            console.load(newInstructions)
            console.run()
        }

        waitForExpectations(timeout: 30)
    }
}
