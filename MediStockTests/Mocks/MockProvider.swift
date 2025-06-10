//
//  MockAisleProvider.swift
//  MediStock
//
//  Created by Bruno Evrard on 10/06/2025.
//

@testable import MediStock
import Foundation
class MockProvider {
    static func generateAisles(count: Int = 10) -> [Aisle] {
        var aisles: [Aisle] = []
        for i in 1...count {
            let name = "Allée \(i)"
            let sortKey = String(format: "%02d", i)
            let aisle = Aisle(
                id: "\(i)",
                name: name,
                nameSearch: name.lowercased(),
                sortKey: sortKey
            )
            aisles.append(aisle)
        }
        return aisles
    }
}
