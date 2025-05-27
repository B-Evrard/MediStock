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
    func streamAisles() -> AsyncThrowingStream<[Aisle], Error> {
        AsyncThrowingStream { [weak self] continuation in
            guard let self = self else {
                continuation.finish(throwing: CancellationError())
                return
            }
            
            self.loadNextPageAisles { result in
                switch result {
                case .success(let aisles):
                    continuation.yield(aisles)
                case .failure(let error):
                    continuation.finish(throwing: error)
                }
            }
            
            continuation.onTermination = { @Sendable _ in
                self.detachAisleListener()
            }
        }
    }
    
    func loadNextPageAisles(completion: @escaping (Result<[Aisle], Error>) -> Void) {
        
        detachAisleListener()
        
        var query = db.collection("Aisles")
            .order(by: "sortKey")
            .limit(to: aislePageSize)
        
        if let lastDoc = lastAisleDocument {
            query = query.start(afterDocument: lastDoc)
        }
        
        activeAisleListener = query.addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let snapshot = snapshot else {
                completion(.success([]))
                return
            }
            
            lastAisleDocument = snapshot.documents.last
            
            let aisles = snapshot.documents.compactMap { document -> Aisle? in
                try? document.data(as: Aisle.self)
            }
            
            completion(.success(aisles))
        }
    }
    
    func detachAisleListener() {
            activeAisleListener?.remove()
            activeAisleListener = nil
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
