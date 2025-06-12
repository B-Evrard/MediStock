//
//  MockFBStoreService.swift
//  MediStockTests
//
//  Created by Bruno Evrard on 10/06/2025.
//

import Foundation
@testable import MediStock

class MockFBStoreService: DataStore {
   
    var usersValid = MockProvider.mockUsers
    var shouldSucceed: Bool = true
    var medicineUpdates: MedicineUpdateModel = MedicineUpdateModel()
    let mockError = NSError(domain: "MockFBStoreService", code: 1, userInfo: nil)
    private var continuation: AsyncThrowingStream<MedicineUpdateModel, Error>.Continuation?
    
    func fetchAisles() async throws -> [AisleModel] {
        if (shouldSucceed) {
            return MockProvider.generateAisles()
        } else {
            throw NSError(domain: "MockFBStoreService", code: 1, userInfo: nil) as Error
        }
    }
    
    func addAisle(_ aisle: AisleModel) async throws -> AisleModel {
        let aisle: AisleModel = AisleModel(id: "1", name: "Aisle 1", nameSearch: "", sortKey: "" )
        return aisle
    }
    
    func getAisle(id: String) async throws -> AisleModel {
        let aisle: AisleModel = AisleModel(id: "1", name: "Aisle 1", nameSearch: "", sortKey: "" )
        return aisle
    }
    
    func streamMedicines(aisleId: String?, filter: String?, sortOption: SortOption?) -> AsyncThrowingStream<MedicineUpdateModel, Error> {
        return AsyncThrowingStream { continuation in
            self.continuation = continuation
            var initialUpdate = MedicineUpdateModel()
            let allMedicines = MockProvider.getMockMedicines()
            
            if let filter = filter, !filter.isEmpty {
                initialUpdate.added = allMedicines.filter {
                    $0.nameSearch?.uppercased().hasPrefix(filter.uppercased()) ?? false
                }
            } else {
                initialUpdate.added = allMedicines
            }
            continuation.yield(initialUpdate)
         }
    }
    
    
    func send(update: MedicineUpdateModel) {
        continuation?.yield(update)
    }
    
    func sendError() {
        continuation?.finish(throwing: mockError)
    }
    
    func finishStream() {
        continuation?.finish()
    }
    
    func resetStreamMedicines() {
        
    }
    
    func getMedicine(id: String) async throws -> MedicineModel {
        let Medicine = MedicineModel.init(id:"", aisleId: "", name: "", stock: 0)
        return Medicine
    }
    
    func medicineExistByNameAndAisle(name: String, aisleId: String) async throws -> Bool {
        return false
    }
    
    func addMedicine(_ medicine: MedicineModel) async throws -> MedicineModel {
        let Medicine = MedicineModel.init(id:"", aisleId: "", name: "", stock: 0)
        return Medicine
    }
    
    func updateMedicine(_ medicine: MedicineModel) async throws {
        
    }
    
    func deleteMedicine(id: String) async throws {
        if (shouldSucceed) {
            let expectedUpdate = MedicineUpdateModel(
                added: [],
                modified: [],
                removedIds: [id]
            )
            send(update: expectedUpdate)
        } else {
            throw NSError(domain: "MockFBStoreService", code: 1, userInfo: nil) as Error
        }
    }
    
    func fetchHistory(medicineId: String) async throws -> [HistoryEntryModel] {
        let allHistory: [HistoryEntryModel] = MockProvider.historyEntries
        let history = medicineId.isEmpty ? allHistory : allHistory.filter { $0.medicineId == medicineId }
        return history
    }
    
    func addHistory(_ historyEntry: HistoryEntryModel) async throws -> HistoryEntryModel {
        let historyEntry = HistoryEntryModel.init(id: "", medicineId: "", action: "", details: "", modifiedAt: Date(), modifiedByUserId: "", modifiedByUserName: "")
        return historyEntry
    }
    
}
