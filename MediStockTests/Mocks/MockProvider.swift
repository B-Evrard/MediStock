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
    
    static func getMockMedicines() -> [Medicine] {
        let mockMedicines: [Medicine] = [
            Medicine(id: "1", aisleId: "1", name: "Paracetamol", stock: 100),
            Medicine(id: "2", aisleId: "2", name: "Ibuprofen", stock: 80),
            Medicine(id: "3", aisleId: "3", name: "Aspirin", stock: 120),
            Medicine(id: "4", aisleId: "1", name: "Doliprane", stock: 95),
            Medicine(id: "5", aisleId: "4", name: "Efferalgan", stock: 60),
            Medicine(id: "6", aisleId: "2", name: "Spasfon", stock: 70),
            Medicine(id: "7", aisleId: "5", name: "Actifed", stock: 130),
            Medicine(id: "8", aisleId: "3", name: "Fervex", stock: 110),
            Medicine(id: "9", aisleId: "6", name: "Lysopaïne", stock: 55),
            Medicine(id: "10", aisleId: "4", name: "Nurofen", stock: 90),
            Medicine(id: "11", aisleId: "7", name: "Smecta", stock: 100),
            Medicine(id: "12", aisleId: "8", name: "Imodium", stock: 75),
            Medicine(id: "13", aisleId: "5", name: "Rhinadvil", stock: 65),
            Medicine(id: "14", aisleId: "6", name: "Hextril", stock: 50),
            Medicine(id: "15", aisleId: "9", name: "Clarix", stock: 40),
            Medicine(id: "16", aisleId: "10", name: "Humex", stock: 85),
            Medicine(id: "17", aisleId: "7", name: "Vicks", stock: 125),
            Medicine(id: "18", aisleId: "8", name: "Gaviscon", stock: 140),
            Medicine(id: "19", aisleId: "9", name: "Maalox", stock: 115),
            Medicine(id: "20", aisleId: "10", name: "Biafine", stock: 160)
        ]
        return mockMedicines
    }
    
}
