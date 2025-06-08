//
//  SessionManager.swift
//  MediStock
//
//  Created by Bruno Evrard on 05/06/2025.
//

import Foundation
import UIKit
import Combine

@MainActor
final class SessionManager: ObservableObject {
    
    // MARK: - Published
    @Published var user: UserInfo?
    @Published var isConnected: Bool
    
    // MARK: - Public
    let storeService: DataStore
    let authService:  AuthProviding
    
    // MARK: - Private
    private var cancellables = Set<AnyCancellable>()
    private var observers: [NSObjectProtocol] = []
    
    // MARK: - Init
    init(user: UserInfo? = nil, storeService: DataStore = FireBaseStoreService(), authService: AuthProviding = FireBaseAuthService()) {
        self.user = user
        self.storeService = storeService
        self.authService = authService
        self.isConnected = authService.isConnected()
        observeAppLifecycle()
        observeAuthChanges()
    }
    
    deinit {
        observers.forEach { NotificationCenter.default.removeObserver($0) }
    }
    
    // MARK: - Public methods
    func signOut() async throws {
        try await authService.signOut()
        await MainActor.run {
            resetUser()
        }
    }
    
    func updateUser(userId: String) async {
        do {
            let userInfo = try await self.storeService.getUser(idAuth: userId)
            self.user = userInfo
            self.isConnected = user != nil
        } catch {
            self.resetUser()
        }
    }
    
    func resetUser() {
        stopListeners()
        self.user = nil
        self.isConnected = false
    }
    
    func stopListeners() {
        authService.removeListener()
    }
    
    // MARK: - Private methods
    private func observeAuthChanges() {
        authService.listen()
        authService.userIdPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] userId in
                guard let self = self else { return }
                Task {
                    guard let userId = userId else {
                        self.resetUser()
                        return
                    }
                    await self.updateUser(userId: userId)
                }
            }
            .store(in: &cancellables)
    }
    
    private func observeAppLifecycle() {
        let center = NotificationCenter.default
        
        let terminationObserver = center.addObserver(
            forName: UIApplication.willTerminateNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.stopListeners()
            }
        }
        observers.append(terminationObserver)
    }
}
