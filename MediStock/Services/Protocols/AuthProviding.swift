//
//  AuthProviding.swift
//  MediStock
//
//  Created by Bruno Evrard on 22/05/2025.
//


import FirebaseAuth

protocol AuthProviding {
    
    func listen()
    func signIn(withEmail email: String, password: String) async throws -> UserInfo?
    func signUp(withEmail email: String, password: String) async throws -> UserInfo?
    
}
