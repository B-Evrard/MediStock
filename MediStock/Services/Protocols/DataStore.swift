//
//  DataStore.swift
//  MediStock
//
//  Created by Bruno Evrard on 22/05/2025.
//


protocol DataStore {
    
    // MARK: Aisles
    func streamAisles() throws -> AsyncThrowingStream<[Aisle], Error>
    func loadNextPageAisles(completion: @escaping (Result<[Aisle], Error>) -> Void)
    func detachAisleListener()
    
    // MARK: Medicines
    //func fetchMedicines(forAisle aisle: Aisle) -> AsyncThrowingStream<[Medicine], Error>
    //func fetchMedicines() -> AsyncThrowingStream<[Medicine], Error>
    
    // MARK: History
    
    // MARK: User
    func addUser(_ user: UserInfo) async throws
    func getUser(idAuth: String) async throws -> UserInfo?
}
