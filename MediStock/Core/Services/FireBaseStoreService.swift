//
//  FireStoreService.swift
//  MediStock
//
//  Created by Bruno Evrard on 23/05/2025.
//

import Foundation
import FirebaseFirestore
final class FireBaseStoreService: DataStore {
    
    let db = Firestore.firestore()
    private var listenerMedicine: ListenerRegistration?
    
    // MARK: Aisle
    func fetchAisles() async throws -> [Aisle] {
        var aisles: [Aisle] = []
        let query = db.collection("Aisles")
            .order(by: "sortKey")
        
        let snapshot = try await query.getDocuments()
        
        aisles = snapshot.documents.compactMap { document -> Aisle? in
            try? document.data(as: Aisle.self)
        }
        return aisles
    }
    
    func addAisle(_ aisle: Aisle) async throws -> Aisle{
        let ref = try db.collection("Aisles").addDocument(from: aisle)
        return try await ref.getDocument().data(as: Aisle.self)
    }
    
    func getAisle(id: String) async throws -> Aisle {
        let ref = db.collection("Aisles").document(id)
        let aisle = try await ref.getDocument(as: Aisle.self)
        return aisle
    }
    
    // MARK: Medicines
    func getMedicine(id: String) async throws -> Medicine {
        let ref = db.collection("Medicines").document(id)
        let medicine = try await ref.getDocument(as : Medicine.self)
        return medicine
    }
    
    func medicineExistByNameAndAisle(name: String, aisleId: String) async throws -> Bool {
        let FBMedicines = db.collection("Medicines")
        var query: Query
        query = FBMedicines
            .whereField("nameSearch", isEqualTo: name.removingAccentsUppercased)
            .whereField("aisleId", isEqualTo: aisleId)
        let snapshot = try await query.getDocuments()
        return snapshot.documents.count>0
    }
    
    func addMedicine(_ medicine: Medicine) async throws -> Medicine {
        let ref = try db.collection("Medicines").addDocument(from: medicine)
        return try await ref.getDocument().data(as: Medicine.self)
    }
    
    func updateMedicine(_ medicine: Medicine) async throws {
        guard let id = medicine.id else {
            throw ControlError.genericError()
        }
        try db.collection("Medicines").document(id).setData(from: medicine)
    }
    
    func deleteMedicine(id: String) async throws {
        try await db.collection("Medicines").document(id).delete()
    }
    
    func streamMedicines(aisleId: String?) -> AsyncThrowingStream<MedicineUpdate, Error> {
        AsyncThrowingStream { [weak self] continuation in
            guard let self else {
                continuation.finish(throwing: CancellationError())
                return
            }
            
            let FBMedicines = db.collection("Medicines")
            var query: Query
            
            if let aisleId {
                query = FBMedicines.whereField("aisleId", isEqualTo: aisleId).order(by: "name")
            } else {
                query = FBMedicines.order(by: "name")
            }
            resetStreamMedicines()
            self.listenerMedicine = query.addSnapshotListener { snapshot, error in
                if let error {
                    continuation.finish(throwing: error)
                    return
                }
                var mediciceUpdates = MedicineUpdate()
                guard let snapshot else {
                    continuation.yield(mediciceUpdates)
                    return
                }

                let added = snapshot.documentChanges
                    .filter { $0.type == .added }
                    .compactMap { try? $0.document.data(as: Medicine.self) }
                
                let modified = snapshot.documentChanges
                    .filter { $0.type == .modified }
                    .compactMap { try? $0.document.data(as: Medicine.self) }
                
                let removedIds = snapshot.documentChanges
                    .filter { $0.type == .removed }
                    .map { $0.document.documentID }
                
                mediciceUpdates.added = added
                mediciceUpdates.modified = modified
                mediciceUpdates.removedIds = removedIds
                
                continuation.yield(mediciceUpdates)
            }
            
            continuation.onTermination = { [weak self] _ in
                self?.listenerMedicine?.remove()
            }
        }
    }
    
    func resetStreamMedicines() {
        listenerMedicine?.remove()
    }
    
    
    // MARK: History
    func fetchHistory(medicineId: String) async throws -> [HistoryEntry] {
        let FBHistory = db.collection("History")
        var query: Query
        query = FBHistory
            .whereField("medicineId", isEqualTo: medicineId)
            .order(by: "modifiedAt")
        let snapshot = try await query.getDocuments()
        let historyEntries = snapshot.documents.compactMap { document -> HistoryEntry? in
            try? document.data(as: HistoryEntry.self)
        }
        return historyEntries
    }
    
    func addHistory(_ historyEntry: HistoryEntry) async throws -> HistoryEntry {
        let ref = try db.collection("History").addDocument(from: historyEntry)
        return try await ref.getDocument().data(as: HistoryEntry.self)
    }
    
    
    // MARK: User
    
    func addUser(_ user: UserInfo) async throws {
        _ = try db.collection("Users").addDocument(from: user)
    }
    
    func getUser(idAuth: String) async throws -> UserInfo? {
        var user: UserInfo?
        let FBUsers = db.collection("Users")
        let snapshot = try await FBUsers.whereField("idAuth", isEqualTo: idAuth).getDocuments()
        if (!snapshot.isEmpty) {
            user = try snapshot.documents[0].data(as : UserInfo.self)
        }
        return user
    }
    
    
    
    
}
