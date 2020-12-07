//
//  Day7Tests.swift
//  aoc-2020Tests
//
//  Created by Markus Krischke on 07.12.20.
//

import XCTest


class Day7Tests: XCTestCase {

    class Node: Hashable {
        var name: String
        var parents: [Node] = []
        var children: [Node: Int] = [:]

        init(name: String) {
            self.name = name
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(name)
        }

        static func == (lhs: Day7Tests.Node, rhs: Day7Tests.Node) -> Bool {
            return lhs.name == rhs.name
        }
    }

    func testDay7_1() throws {
        let shiny = loadNodes()["shiny gold"]!
        XCTAssertEqual(326, collectParents(node: shiny).count)
    }

    func testDay7_2() throws {
        let shiny = loadNodes()["shiny gold"]!
        XCTAssertEqual(5635, collectChildren(node: shiny) - 1)
    }

    private func collectParents(node: Node) -> Set<Node> {
        var parents = Set(node.parents)
        for parent in node.parents {
            parents.formUnion(collectParents(node: parent))
        }
        return parents
    }

    private func collectChildren(node: Node) -> Int {
        var count = 1
        for child in node.children {
            count += child.value * collectChildren(node: child.key)
        }
        return count
    }

    private func loadNodes() -> [String: Node] {
        let data = loadData()
            .replacingOccurrences(of: "bags.", with: "")
            .replacingOccurrences(of: "bag.", with: "")
            .replacingOccurrences(of: " bags", with: "")
            .replacingOccurrences(of: " bag", with: "")

        var nodes: [String: Node] = [:]

        for constraint in data.components(separatedBy: "\n").filter({ !$0.isEmpty }) {
            let parts = constraint.components(separatedBy: "contain")
            let container = parts[0].trimmingCharacters(in: .whitespaces)

            let parent = nodes[container] ?? Node(name: container)

            let contents = parts[1].components(separatedBy: ", ").map { $0.trimmingCharacters(in: .whitespaces) }
            for content in contents where content != "no other" {
                let count = Int(content.prefix(1))!
                let name = String(content.dropFirst(2))

                let node = nodes[name] ?? Node(name: name)
                node.parents.append(parent)
                nodes[name] = node

                parent.children[node, default: 0] += count
            }

            nodes[container] = parent
        }
        return nodes
    }

    private func loadData() -> String {
        return loadFile(name: "day7.txt")
    }
}
