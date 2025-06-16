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
    
    private var mockAisles = MockProvider.generateAisles()
    private var mockMedicines = MockProvider.generateMedicines()
    private var mockHistory = MockProvider.historyEntries
    
    func fetchAisles() async throws -> [AisleModel] {
        if (shouldSucceed) {
            return mockAisles
        } else {
            throw NSError(domain: "MockFBStoreService", code: 1, userInfo: nil) as Error
        }
    }
    
    func addAisle(_ aisle: AisleModel) async throws -> AisleModel {
        if (shouldSucceed) {
            let maxID = mockAisles
                .compactMap { $0.id }
                .compactMap { Int($0) }
                .max()

            let nextID = (maxID ?? 0) + 1
            let nextIDString = String(nextID)
            var aisle = aisle
            aisle.id = nextIDString
            mockAisles.append(aisle)
            return aisle
        } else {
            throw NSError(domain: "MockFBStoreService", code: 1, userInfo: nil) as Error
        }
    }
    
    func getAisle(id: String) async throws -> AisleModel {
        if let aisle = mockAisles.first(where: { $0.id == id }) {
            return aisle
        } else {
            throw NSError(domain: "MockFBStoreService", code: 1, userInfo: nil) as Error
        }
        
    }
    
    func streamMedicines(aisleId: String?, filter: String?, sortOption: SortOption?) -> AsyncThrowingStream<MedicineUpdateModel, Error> {
        return AsyncThrowingStream { continuation in
            self.continuation = continuation
            var initialUpdate = MedicineUpdateModel()
            let allMedicines = MockProvider.generateMedicines()
            
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
        if let medicine = mockMedicines.first(where: { $0.id == id}) {
            return medicine
        } else {
            throw NSError(domain: "MockFBStoreService", code: 1, userInfo: nil) as Error
        }
        
    }
    
    func medicineExistByNameAndAisle(name: String, aisleId: String) async throws -> Bool {
        guard mockMedicines.first(where: { $0.name == name && $0.aisleId == aisleId}) != nil else {
            return false
        }
        return true
    }
    
    func addMedicine(_ medicine: MedicineModel) async throws -> MedicineModel {
        if (shouldSucceed) {
            let maxID = mockMedicines
                .compactMap { $0.id }
                .compactMap { Int($0) }
                .max()
            let nextID = (maxID ?? 0) + 1
            let nextIDString = String(nextID)
            var medicineToAdd = medicine
            medicineToAdd.id = nextIDString
            mockMedicines.append(medicineToAdd)
            
            let expectedUpdate = MedicineUpdateModel(
                added: [medicineToAdd],
                modified: [],
                removedIds: []
            )
            send(update: expectedUpdate)
            return medicineToAdd
        } else {
            throw NSError(domain: "MockFBStoreService", code: 1, userInfo: nil) as Error
        }
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
        let history = medicineId.isEmpty ? mockHistory : mockHistory.filter { $0.medicineId == medicineId }
        return history
    }
    
    func addHistory(_ historyEntry: HistoryEntryModel) async throws -> HistoryEntryModel {
        let historyEntry = HistoryEntryModel.init(id: "", medicineId: "", action: "", details: "", modifiedAt: Date(), modifiedByUserId: "", modifiedByUserName: "")
        return historyEntry
    }
    
}
