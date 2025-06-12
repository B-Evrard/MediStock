//
//  MockAisleProvider.swift
//  MediStock
//
//  Created by Bruno Evrard on 10/06/2025.
//

@testable import MediStock
import Foundation
class MockProvider {
    static func generateAisles(count: Int = 10) -> [AisleModel] {
        var aisles: [AisleModel] = []
        for i in 1...count {
            let name = "Allée \(i)"
            let sortKey = String(format: "%02d", i)
            let aisle = AisleModel(
                id: "\(i)",
                name: name,
                nameSearch: name.lowercased(),
                sortKey: sortKey
            )
            aisles.append(aisle)
        }
        return aisles
    }
    
    static func getMockMedicines() -> [MedicineModel] {
        let mockMedicines: [MedicineModel] = [
            MedicineModel(id: "1", aisleId: "1", name: "Paracetamol", stock: 100),
            MedicineModel(id: "2", aisleId: "2", name: "Ibuprofen", stock: 80),
            MedicineModel(id: "3", aisleId: "3", name: "Aspirin", stock: 120),
            MedicineModel(id: "4", aisleId: "1", name: "Doliprane", stock: 95),
            MedicineModel(id: "5", aisleId: "4", name: "Efferalgan", stock: 60),
            MedicineModel(id: "6", aisleId: "2", name: "Spasfon", stock: 70),
            MedicineModel(id: "7", aisleId: "5", name: "Actifed", stock: 130),
            MedicineModel(id: "8", aisleId: "3", name: "Fervex", stock: 110),
            MedicineModel(id: "9", aisleId: "6", name: "Lysopaïne", stock: 55),
            MedicineModel(id: "10", aisleId: "4", name: "Nurofen", stock: 90),
            MedicineModel(id: "11", aisleId: "7", name: "Smecta", stock: 100),
            MedicineModel(id: "12", aisleId: "8", name: "Imodium", stock: 75),
            MedicineModel(id: "13", aisleId: "5", name: "Rhinadvil", stock: 65),
            MedicineModel(id: "14", aisleId: "6", name: "Hextril", stock: 50),
            MedicineModel(id: "15", aisleId: "9", name: "Clarix", stock: 40),
            MedicineModel(id: "16", aisleId: "10", name: "Humex", stock: 85),
            MedicineModel(id: "17", aisleId: "7", name: "Vicks", stock: 125),
            MedicineModel(id: "18", aisleId: "8", name: "Gaviscon", stock: 140),
            MedicineModel(id: "19", aisleId: "9", name: "Maalox", stock: 115),
            MedicineModel(id: "20", aisleId: "10", name: "Biafine", stock: 160)
        ]
        return mockMedicines
    }
    
}
