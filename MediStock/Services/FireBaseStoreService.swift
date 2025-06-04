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
    private let medicinePageSize = 20
    private var lastMedicineDocument: DocumentSnapshot?
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
    
    func streamMedicines(aisleId: String?) -> AsyncThrowingStream<[Medicine], Error> {
        AsyncThrowingStream { [weak self] continuation in
            guard let self = self else {
                continuation.finish(throwing: CancellationError())
                return
            }
            
            self.loadNextPageMedicine(aisleId: aisleId) { result in
                switch result {
                case .success(let medicines):
                    continuation.yield(medicines)
                case .failure(let error):
                    continuation.finish(throwing: error)
                }
            }
            
            continuation.onTermination = { [weak self] _ in
                self?.listenerMedicine?.remove()
            }
        }
    }
    
    func loadNextPageMedicine(aisleId: String?, completion: @escaping (Result<[Medicine], Error>) -> Void) {
        if let listenerMedicine {
            listenerMedicine.remove()
        }
        
        let FBMedicines = db.collection("Medicines")
        
        var query: Query
        
        if let aisleId {
            query = FBMedicines
                .whereField("aisleId", isEqualTo: aisleId)
                .order(by: "name")
                .limit(to: medicinePageSize)
        } else {
            query = FBMedicines
                .order(by: "name")
                .limit(to: medicinePageSize)
        }
        
        if let lastDoc = lastMedicineDocument {
            query = query.start(afterDocument: lastDoc)
        }
        
        listenerMedicine = query.addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let snapshot = snapshot else {
                completion(.success([]))
                return
            }
            
            self.lastMedicineDocument = snapshot.documents.last
            
            let medicines = snapshot.documents.compactMap { document -> Medicine? in
                try? document.data(as: Medicine.self)
            }
            
            completion(.success(medicines))
        }
    }
    
    func resetStreamMedicines() {
        lastMedicineDocument = nil
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
