//
//  SessionManager.swift
//  MediStock
//
//  Created by Bruno Evrard on 05/06/2025.
//

import Foundation
import Combine

final class SessionManager: ObservableObject {
    
    @Published var user: UserInfo?
    @Published var isConnected: Bool
    
    private let storeService: DataStore
    private let authService:  AuthProviding
    private var cancellables = Set<AnyCancellable>()
    
    init(user: UserInfo? = nil, isConnected: Bool, storeService: DataStore = FireBaseStoreService(), authService: AuthProviding = FireBaseAuthService()) {
        self.user = user
        self.isConnected = isConnected
        self.storeService = storeService
        self.authService = authService
    }
    
    private func observeAuthChanges() {
        authService.userIdPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] userId in
                guard let self = self else { return }
                Task {
                    do {
                        guard let userId = userId else {
                            self.resetUser()
                            return
                        }
                        let userInfo = try await self.storeService.getUser(idAuth: userId)
                        self.updateUser(user: userInfo)
                    } catch {
                        self.resetUser()
                    }
                }
            }
            .store(in: &cancellables)
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
