//
//  DataStore.swift
//  MediStock
//
//  Created by Bruno Evrard on 22/05/2025.
//


protocol DataStore {
    
    // MARK: Aisles
    func fetchAisles() async throws -> [Aisle]
    func addAisle(_ aisle: Aisle) async throws -> Aisle
    func getAisle(id: String) async throws -> Aisle
    
    // MARK: Medicines
    func streamMedicines(aisleId: String?, filter: String?, sortOption: SortOption?) -> AsyncThrowingStream<MedicineUpdate, Error>
    func resetStreamMedicines()
    func getMedicine(id: String) async throws -> Medicine
    func medicineExistByNameAndAisle(name: String, aisleId: String) async throws -> Bool
    func addMedicine(_ medicine: Medicine) async throws -> Medicine
    func updateMedicine(_ medicine: Medicine) async throws
    func deleteMedicine(id: String) async throws
    
    // MARK: History
    func fetchHistory(medicineId: String) async throws -> [HistoryEntry]
    func addHistory(_ historyEntry: HistoryEntry) async throws -> HistoryEntry
    
    // MARK: User
    func addUser(_ user: UserInfo) async throws
    func getUser(idAuth: String) async throws -> UserInfo?
}
