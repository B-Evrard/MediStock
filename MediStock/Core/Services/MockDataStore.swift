//
//  MockDataStore.swift
//  MediStock
//
//  Created by Bruno Evrard on 19/06/2025.
//

import Foundation

class MockDataStore: DataStore {
    
    var streamMedicinesHandler: ((String?, String?, SortOption?) -> AsyncThrowingStream<MedicineUpdateModel, any Error>)?
    func fetchAisles() async throws -> [AisleModel] {
        return []
    }
    
    func addAisle(_ aisle: AisleModel) async throws -> AisleModel {
        return AisleModel(id: "1", name: "Aisle 1", nameSearch: "", sortKey: "")
    }
    
    func getAisle(id: String) async throws -> AisleModel {
        return AisleModel(id: "1", name: "Aisle 1", nameSearch: "", sortKey: "")
    }

    func streamMedicines(aisleId: String?, filter: String?, sortOption: SortOption?) -> AsyncThrowingStream<MedicineUpdateModel, any Error> {
        if let handler = streamMedicinesHandler {
            return handler(aisleId, filter, sortOption)
        } else {
            return AsyncThrowingStream { $0.finish() }
        }
    }
 
    
    func resetStreamMedicines() {
        
    }
    
    func getMedicine(id: String) async throws -> MedicineModel {
        return MedicineModel(id: "1", aisleId: "1", name: "Paracetamol", stock: 100)
    }
    
    func medicineExistByNameAndAisle(name: String, aisleId: String) async throws -> Bool {
        return true
    }
    
    func addMedicine(_ medicine: MedicineModel) async throws -> MedicineModel {
        return MedicineModel(id: "1", aisleId: "1", name: "Paracetamol", stock: 100)
    }
    
    func updateMedicine(_ medicine: MedicineModel) async throws {
        
    }
    
    func deleteMedicine(id: String) async throws {
        
    }
    
    func fetchHistory(medicineId: String) async throws -> [HistoryEntryModel] {
        return []
    }
    
    func addHistory(_ historyEntry: HistoryEntryModel) async throws -> HistoryEntryModel {
        return HistoryEntryModel(
            id: "h1",
            medicineId: "1",
            action: "Add",
            details: "Stock : 50 - Aisle : Antibiotics",
            modifiedAt: Calendar.current.date(byAdding: .day, value: -9, to: Date())!,
            modifiedByUserId: "2",
            modifiedByUserName: "Bob Smith"
        )
    }
    
    
}
