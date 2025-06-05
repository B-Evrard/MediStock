//
//  SessionManager.swift
//  MediStock
//
//  Created by Bruno Evrard on 05/06/2025.
//

import Foundation

final class SessionManager: ObservableObject {
    
    @Published var user: UserInfo?
    @Published var isConnected: Bool
    
    private let storeService: DataStore
    private let authService:  AuthProviding
    
    
    
    
}
