//
//  AuthProviding.swift
//  MediStock
//
//  Created by Bruno Evrard on 22/05/2025.
//


import FirebaseAuth
import Combine

protocol AuthProviding {
    
    var userIdPublisher: PassthroughSubject<String?, Never> { get }
    
    func isConnected() -> Bool
    func listen ()
    func signIn(withEmail email: String, password: String) async throws -> String?
    func signUp(withEmail email: String, password: String) async throws -> MediStockUser?
    func signOut() async throws
    func removeListener()
    
    // MARK: User
    func addUser(_ user: MediStockUser) async throws
    func getUser(idAuth: String) async throws -> MediStockUser?
}
