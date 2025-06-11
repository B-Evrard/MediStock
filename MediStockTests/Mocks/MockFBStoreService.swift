//
//  MockFBStoreService.swift
//  MediStockTests
//
//  Created by Bruno Evrard on 10/06/2025.
//

import Foundation
@testable import MediStock

class MockFBStoreService: DataStore {
   
    var usersValid = MockUsers.mockUsers
    var shouldSucceed: Bool = true
    var medicineUpdates: MedicineUpdate = MedicineUpdate()
    let mockError = NSError(domain: "MockFBStoreService", code: 1, userInfo: nil)
    private var continuation: AsyncThrowingStream<MedicineUpdate, Error>.Continuation?
    
    func fetchAisles() async throws -> [Aisle] {
        if (shouldSucceed) {
            return MockProvider.generateAisles()
        } else {
            throw NSError(domain: "MockFBStoreService", code: 1, userInfo: nil) as Error
        }
    }
    
    func addAisle(_ aisle: Aisle) async throws -> Aisle {
        let aisle: Aisle = Aisle(id: "1", name: "Aisle 1", nameSearch: "", sortKey: "" )
        return aisle
    }
    
    func getAisle(id: String) async throws -> Aisle {
        let aisle: Aisle = Aisle(id: "1", name: "Aisle 1", nameSearch: "", sortKey: "" )
        return aisle
    }
    
    func streamMedicines(aisleId: String?, filter: String?, sortOption: SortOption?) -> AsyncThrowingStream<MedicineUpdate, Error> {
        return AsyncThrowingStream { continuation in
            self.continuation = continuation
            var initialUpdate = MedicineUpdate()
            guard let filter = filter else {
                initialUpdate.added = MockProvider.getMockMedicines()
                continuation.yield(initialUpdate)
                return
            }
            if filter.isEmpty {
                initialUpdate.added = MockProvider.getMockMedicines()
                continuation.yield(initialUpdate)
            }  else {
//                initialUpdate.added = MockProvider.getMockMedicines().filter {
//                    $0.nameSearch?.uppercased().hasPrefix(filter)
//                }
                continuation.yield(initialUpdate)
            }
           
                
           
            
         }
    }
    
    
    func send(update: MedicineUpdate) {
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
    
    func getMedicine(id: String) async throws -> Medicine {
        let Medicine = Medicine.init(id:"", aisleId: "", name: "", stock: 0)
        return Medicine
    }
    
    func medicineExistByNameAndAisle(name: String, aisleId: String) async throws -> Bool {
        return false
    }
    
    func addMedicine(_ medicine: Medicine) async throws -> Medicine {
        let Medicine = Medicine.init(id:"", aisleId: "", name: "", stock: 0)
        return Medicine
    }
    
    func updateMedicine(_ medicine: Medicine) async throws {
        
    }
    
    func deleteMedicine(id: String) async throws {
        let expectedUpdate = MedicineUpdate(
            added: [],
            modified: [],
            removedIds: [id]
        )
        send(update: expectedUpdate)
    }
    
    func fetchHistory(medicineId: String) async throws -> [HistoryEntry] {
        let history: [HistoryEntry] = []
        return history
    }
    
    func addHistory(_ historyEntry: HistoryEntry) async throws -> HistoryEntry {
        let historyEntry = HistoryEntry.init(id: "", medicineId: "", action: "", details: "", modifiedAt: Date(), modifiedByUserId: "", modifiedByUserName: "")
        return historyEntry
    }
    
    func addUser(_ user: MediStockUser) async throws {
        let newUser = user
        usersValid.append(newUser)
    }
    
    func getUser(idAuth: String) async throws -> MediStockUser? {
        if shouldSucceed {
            if let foundUser = usersValid.first(where: { $0.idAuth == idAuth }) {
                return foundUser
            } else {
                throw mockError
            }
        } else {
            throw mockError
        }
    }
    
    
    
}
