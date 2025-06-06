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
    
    init(user: UserInfo? = nil, isConnected: Bool, storeService: DataStore = FireBaseStoreService, authService: AuthProviding = FireBaseAuthService()) {
        self.user = user
        self.isConnected = isConnected
        self.storeService = storeService
        self.authService = authService
    }
    
    func updateUser(user: UserInfo?) {
        self.user = user
        self.isConnected = user != nil
    }

    func resetUser() {
        self.user = nil
        self.isConnected = false
    }

    func signOut() async throws {
        try await authService.signOut()
        await MainActor.run {
            resetUser()
        }
    }
}
