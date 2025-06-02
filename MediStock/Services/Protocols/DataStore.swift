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
    
    // MARK: Medicines
    //func fetchMedicines(forAisle aisle: Aisle) -> AsyncThrowingStream<[Medicine], Error>
    //func fetchMedicines() -> AsyncThrowingStream<[Medicine], Error>
    func getMedicine(id: String) async throws -> Medicine
    func addMedicine(_ medicine: Medicine) async throws -> Medicine
    func updateMedicine(_ medicine: Medicine) async throws
    
    // MARK: History
    func addHistory(_ historyEntry: HistoryEntry) async throws -> HistoryEntry
    
    // MARK: User
    func addUser(_ user: UserInfo) async throws
    func getUser(idAuth: String) async throws -> UserInfo?
}
