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
    
    
    // MARK: Medicines
//    func fetchMedicines(forAisle aisle: Aisle) -> AsyncThrowingStream<[Medicine], any Error> {
//        
//    }
//    
//    func fetchMedicines() -> AsyncThrowingStream<[Medicine], any Error> {
//        
//    }
    
    // MARK: History
    
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
