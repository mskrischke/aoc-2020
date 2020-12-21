//
//  Day21Tests.swift
//  aoc-2020Tests
//
//  Created by Markus Krischke on 21.12.20.
//

import XCTest

class Day21Tests: XCTestCase {

    func testDay21() throws {
        let d = load()
        
        var recipesPerAllergen: [String: [[String]]] = [:]
        d.forEach { entry in entry.allergens.forEach { recipesPerAllergen[$0, default: []].append(entry.ingredients) } }
        
        while recipesPerAllergen.contains(where: { $0.value[0].count > 1 }) {
            for allergen in recipesPerAllergen.keys {
                var recipes = recipesPerAllergen[allergen]!
                var ingredients = Set(recipes.removeFirst())
                for recipe in recipes {
                    ingredients.formIntersection(recipe)
                }
                
                if ingredients.count == 1 {
                    for r in recipesPerAllergen {
                        for (i,p) in r.value.enumerated() {
                            recipesPerAllergen[r.key]![i] = p.filter { $0 != ingredients.first! }
                        }
                    }
                    recipesPerAllergen[allergen] = [[ingredients.first!]]
                }
            }
        }
        
        let allIngredients = Set(d.flatMap { $0.ingredients })
        let allergenIngredients = Set(recipesPerAllergen.values.flatMap { $0 }.flatMap { $0 })
        let safeIngredients = allIngredients.subtracting(allergenIngredients)
        
        var count = 0
        for ingredient in safeIngredients {
            for recipe in d.map({ $0.ingredients }) {
                if recipe.contains(ingredient) {
                    count += 1
                }
            }
        }
        XCTAssertEqual(count, 2734)
        
        let canonicalList = recipesPerAllergen.map { ($0.key,$0.value[0][0]) }.sorted(by: { $0.0 < $1.0 }).map { $0.1 }.joined(separator: ",")
        XCTAssertEqual(canonicalList, "kbmlt,mrccxm,lpzgzmk,ppj,stj,jvgnc,gxnr,plrlg")
    }
    
    private func load() -> [(ingredients: [String], allergens: [String])] {
       let parts = loadFile(name: "day21.txt")
            .components(separatedBy: "\n")
            .filter { !$0.isEmpty }
            .map { $0.components(separatedBy: " (contains ") }
            .map { ($0[0], $0[1].replacingOccurrences(of: ")", with: "")) }
            .map { ($0.0.components(separatedBy: " "), $0.1.components(separatedBy: ", ")) }
        return parts
    }
}
