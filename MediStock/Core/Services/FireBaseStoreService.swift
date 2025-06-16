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
    func fetchAisles() async throws -> [AisleModel] {
        var aisles: [AisleModel] = []
        let query = db.collection("Aisles")
            .order(by: "sortKey")
        
        let snapshot = try await query.getDocuments()
        
        aisles = snapshot.documents.compactMap { document -> AisleModel? in
            try? document.data(as: AisleModel.self)
        }
        return aisles
    }
    
    func addAisle(_ aisle: AisleModel) async throws -> AisleModel{
        let ref = try db.collection("Aisles").addDocument(from: aisle)
        return try await ref.getDocument().data(as: AisleModel.self)
    }
    
    func getAisle(id: String) async throws -> AisleModel {
        let ref = db.collection("Aisles").document(id)
        let aisle = try await ref.getDocument(as: AisleModel.self)
        return aisle
    }
    
    // MARK: Medicines
    func getMedicine(id: String) async throws -> MedicineModel {
        let ref = db.collection("Medicines").document(id)
        let medicine = try await ref.getDocument(as : MedicineModel.self)
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
    
    func addMedicine(_ medicine: MedicineModel) async throws -> MedicineModel {
        let ref = try db.collection("Medicines").addDocument(from: medicine)
        return try await ref.getDocument().data(as: MedicineModel.self)
    }
    
    func updateMedicine(_ medicine: MedicineModel) async throws {
        guard let id = medicine.id else {
            throw ControlError.genericError()
        }
        try db.collection("Medicines").document(id).setData(from: medicine)
    }
    
    func deleteMedicine(id: String) async throws {
        try await db.collection("Medicines").document(id).delete()
    }
    
    func streamMedicines(aisleId: String?, filter: String?, sortOption: SortOption?) -> AsyncThrowingStream<MedicineUpdateModel, Error> {
        AsyncThrowingStream { [weak self] continuation in
            guard let self else {
                continuation.finish(throwing: CancellationError())
                return
            }
            
            let FBMedicines = db.collection("Medicines")
            var query: Query
            
            if let aisleId {
                query = FBMedicines.whereField("aisleId", isEqualTo: aisleId)
            } else {
                query = FBMedicines
            }
            if let filter = filter, !filter.isEmpty  {
                query = query.whereField("nameSearch", isGreaterThanOrEqualTo: filter.removingAccentsUppercased)
                            .whereField("nameSearch", isLessThanOrEqualTo: "\(filter.removingAccentsUppercased)~")
            }
            if let sortOption = sortOption {
                switch sortOption {
                case .name:
                    query = query.order(by: "name")
                case .stock:
                    query = query.order(by: "stock")
                }
            } else {
                query = query.order(by: "name")
            }
            
            resetStreamMedicines()
            self.listenerMedicine = query.addSnapshotListener { snapshot, error in
                if let error {
                    continuation.finish(throwing: error)
                    return
                }
                var medicineUpdates = MedicineUpdateModel()
                guard let snapshot else {
                    continuation.yield(medicineUpdates)
                    return
                }

                let added = snapshot.documentChanges
                    .filter { $0.type == .added }
                    .compactMap { try? $0.document.data(as: MedicineModel.self) }
                
                let modified = snapshot.documentChanges
                    .filter { $0.type == .modified }
                    .compactMap { try? $0.document.data(as: MedicineModel.self) }
                
                let removedIds = snapshot.documentChanges
                    .filter { $0.type == .removed }
                    .map { $0.document.documentID }
                
                medicineUpdates.added = added
                medicineUpdates.modified = modified
                medicineUpdates.removedIds = removedIds
                
                continuation.yield(medicineUpdates)
            }
            print("Add listener \(listenerMedicine.debugDescription) ")
            
            continuation.onTermination = { [weak self] _ in
                self?.resetStreamMedicines()
            }
        }
    }
    
    func resetStreamMedicines() {
        print("Remove listener \(listenerMedicine.debugDescription) ")
        listenerMedicine?.remove()
    }
    
    
    // MARK: History
    func fetchHistory(medicineId: String) async throws -> [HistoryEntryModel] {
        let FBHistory = db.collection("History")
        var query: Query
        query = FBHistory
            .whereField("medicineId", isEqualTo: medicineId)
            .order(by: "modifiedAt")
        let snapshot = try await query.getDocuments()
        let historyEntries = snapshot.documents.compactMap { document -> HistoryEntryModel? in
            try? document.data(as: HistoryEntryModel.self)
        }
        return historyEntries
    }
    
    func addHistory(_ historyEntry: HistoryEntryModel) async throws -> HistoryEntryModel {
        let ref = try db.collection("History").addDocument(from: historyEntry)
        return try await ref.getDocument().data(as: HistoryEntryModel.self)
    }
    
    
    
}
