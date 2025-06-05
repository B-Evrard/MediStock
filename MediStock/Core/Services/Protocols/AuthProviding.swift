//
//  AuthProviding.swift
//  MediStock
//
//  Created by Bruno Evrard on 22/05/2025.
//


import FirebaseAuth

protocol AuthProviding: ObservableObject{
    
    var user: UserInfo? { get }
    
    func updateUser(user: UserInfo?)
    func resetUser()
    func listen()
    func signIn(withEmail email: String, password: String) async throws -> String?
    func signUp(withEmail email: String, password: String) async throws -> UserInfo?
    func signOut() async throws
    
}
