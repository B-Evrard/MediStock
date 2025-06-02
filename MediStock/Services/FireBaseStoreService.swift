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
    private let aislePageSize = 20
    private var lastAisleDocument: DocumentSnapshot?
    private var activeAisleListener: ListenerRegistration?
    
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
    
    // MARK: Medicines
    func getMedicine(id: String) async throws -> Medicine {
        let ref = db.collection("Medicines").document(id)
        let medicine = try await ref.getDocument(as : Medicine.self)
        return medicine
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
    
    // MARK: History
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
