//
//  Day18Tests.swift
//  aoc-2020Tests
//
//  Created by Markus Krischke on 18.12.20.
//

import XCTest

class Day18Tests: XCTestCase {
    
    class Calculator {
        var output: [String.Element] = []
        var operators: [String.Element] = []
        
        /// https://en.wikipedia.org/wiki/Shunting-yard_algorithm
        
        /// + and * have same precedence
        func parse(input: String) {
            output = []
            operators = []
            
            for c in input {
                if c.isWhitespace { continue }
                
                if c.isNumber {
                    output.append(c)
                } else if c=="+" || c=="*" {
                    
                    while let first = operators.first, (first == "+" || (first == "*")) && first != "(" {
                        output.append(operators.removeFirst())
                    }
                    
                    operators.insert(c, at: 0)
                } else if c == "(" {
                    operators.insert(c, at: 0)
                } else if c == ")" {
                    while let first = operators.first, first != "(" {
                        output.append(operators.removeFirst())
                    }
                    
                    if operators.first == "(" {
                        operators.removeFirst()
                    }
                }
            }
            
            for o in operators {
                output.append(o)
            }
            
            print(output)
        }
        
        /// + has greater precedence
        func parse2(input: String) {
            output = []
            operators = []
            
            for c in input {
                if c.isWhitespace { continue }
                
                if c.isNumber {
                    output.append(c)
                } else if c=="+" || c=="*" {
                    while let first = operators.first, (first == "+") && first != "(" {
                        output.append(operators.removeFirst())
                    }
                    operators.insert(c, at: 0)
                } else if c == "(" {
                    operators.insert(c, at: 0)
                } else if c == ")" {
                    while let first = operators.first, first != "(" {
                        output.append(operators.removeFirst())
                    }
                    
                    if operators.first == "(" {
                        operators.removeFirst()
                    }
                }
            }
            
            for o in operators {
                output.append(o)
            }
            
            print(output)
        }
        
        func calculate() -> Int {
            var stack: [Int] = []
            
            for c in output {
                if c.isNumber {
                    stack.append(c.wholeNumberValue!)
                } else if c == "+" {
                    let result = stack.removeLast() + stack.removeLast()
                    stack.append(result)
                } else if c == "*" {
                    let result = stack.removeLast() * stack.removeLast()
                    stack.append(result)
                }
            }
            return stack.removeLast()
        }
    }

    func testDay18_1() throws {
        let calc = Calculator()
        calc.parse(input: "2 * 3 + (4 * 5)")
        
        let tests = ["1 + 2 * 3 + 4 * 5 + 6": 71,
                     "2 * 3 + (4 * 5)": 26,
                     "5 + (8 * 3 + 9 + 3 * 4 * 3)": 437,
                     "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))": 12240,
                     "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2": 13632]
        
        for t in tests {
            calc.parse(input: t.key)
            let result = calc.calculate()
            XCTAssertEqual(result, t.value)
        }
        
        var result = 0
        for t in loadData() {
            calc.parse(input: t)
            result += calc.calculate()
        }
        XCTAssertEqual(result, 4696493914530)
    }
    
    func testDay18_2() throws {
        let calc = Calculator()
        
        let tests = ["1 + 2 * 3 + 4 * 5 + 6": 231,
                     "2 * 3 + (4 * 5)": 46,
                     "5 + (8 * 3 + 9 + 3 * 4 * 3)": 1445,
                     "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))": 669060,
                     "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2": 23340]
        
        for t in tests {
            calc.parse2(input: t.key)
            let result = calc.calculate()
            XCTAssertEqual(result, t.value)
        }
        
        var result = 0
        for t in loadData() {
            calc.parse2(input: t)
            result += calc.calculate()
        }
        XCTAssertEqual(result, 362880372308125)
    }
    
    private func loadData() -> [String] {
        let data = loadFile(name: "day18.txt")
        return data.components(separatedBy: "\n").filter { !$0.isEmpty }
    }
}
