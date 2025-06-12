//
//  MockAisleProvider.swift
//  MediStock
//
//  Created by Bruno Evrard on 10/06/2025.
//

@testable import MediStock
import Foundation
class MockProvider {
    static let mockUser = UserModel(
        idAuth: "1",
        displayName: "Alice Johnson",
        email: "alice.johnson@example.com",
    )
    
    static let mockUsers: [UserModel] = [
        mockUser,
        UserModel(
            idAuth: "2",
            displayName: "Bob Smith",
            email: "bob.smith@example.com",
        ),
        UserModel(
            idAuth: "3",
            displayName: "Charlie Lee",
            email: "charlie.lee@example.com",
        )
    ]
    
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
    
    static let historyEntries: [HistoryEntryModel] = [
        HistoryEntryModel(
            id: "h1",
            medicineId: "1",
            action: "Add",
            details: "Stock : 50 - Aisle : Antibiotics",
            modifiedAt: Calendar.current.date(byAdding: .day, value: -9, to: Date())!,
            modifiedByUserId: "2",
            modifiedByUserName: "Bob Smith"
        ),
        HistoryEntryModel(
            id: "h2",
            medicineId: "1",
            action: "Update",
            details: "Stock : 50 --> 40",
            modifiedAt: Calendar.current.date(byAdding: .day, value: -8, to: Date())!,
            modifiedByUserId: "3",
            modifiedByUserName: "Charlie Lee"
        ),
        HistoryEntryModel(
            id: "h3",
            medicineId: "1",
            action: "Update",
            details: "Aisle : Antibiotics --> Painkillers",
            modifiedAt: Calendar.current.date(byAdding: .day, value: -7, to: Date())!,
            modifiedByUserId: "2",
            modifiedByUserName: "Bob Smith"
        ),
        HistoryEntryModel(
            id: "h4",
            medicineId: "1",
            action: "Update",
            details: "Rename : Amoxicillin - Stock : 40 --> 35",
            modifiedAt: Calendar.current.date(byAdding: .day, value: -6, to: Date())!,
            modifiedByUserId: "3",
            modifiedByUserName: "Charlie Lee"
        ),
        HistoryEntryModel(
            id: "h5",
            medicineId: "1",
            action: "Delete",
            details: "Amoxicillin - Aisle : Painkillers",
            modifiedAt: Calendar.current.date(byAdding: .day, value: -5, to: Date())!,
            modifiedByUserId: "2",
            modifiedByUserName: "Bob Smith"
        ),
        HistoryEntryModel(
            id: "h6",
            medicineId: "2",
            action: "Add",
            details: "Stock : 30 - Aisle : Vitamins",
            modifiedAt: Calendar.current.date(byAdding: .day, value: -4, to: Date())!,
            modifiedByUserId: "3",
            modifiedByUserName: "Charlie Lee"
        ),
        HistoryEntryModel(
            id: "h7",
            medicineId: "2",
            action: "Update",
            details: "Stock : 30 --> 28",
            modifiedAt: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
            modifiedByUserId: "2",
            modifiedByUserName: "Bob Smith"
        ),
        HistoryEntryModel(
            id: "h8",
            medicineId: "2",
            action: "Update",
            details: "Rename : Vitamin D",
            modifiedAt: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
            modifiedByUserId: "3",
            modifiedByUserName: "Charlie Lee"
        ),
        HistoryEntryModel(
            id: "h9",
            medicineId: "2",
            action: "Update",
            details: "Rename : Vitamin D3 - Aisle : Vitamins --> Supplements",
            modifiedAt: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            modifiedByUserId: "2",
            modifiedByUserName: "Bob Smith"
        ),
        HistoryEntryModel(
            id: "h10",
            medicineId: "2",
            action: "Delete",
            details: "Vitamin D3 - Aisle : Supplements",
            modifiedAt: Date(),
            modifiedByUserId: "3",
            modifiedByUserName: "Charlie Lee"
        )
    ]
}
