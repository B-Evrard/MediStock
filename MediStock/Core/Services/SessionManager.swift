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
    @Published var user: UserModel?
    @Published var isConnected: Bool
    
    // MARK: - Public
    let authService:  AuthProviding
    
    // MARK: - Private
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(user: UserModel? = nil, authService: AuthProviding = FireBaseAuthService()) {
        self.user = user
        self.authService = authService
        self.isConnected = authService.isConnected()
        observeAppLifecycle()
        observeAuthChanges()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willTerminateNotification, object: nil)
    }
    
    // MARK: - Public methods
    func signOut() async throws {
        try await authService.signOut()
        await MainActor.run {
            clearSession()
        }
    }
    
    func updateUser(userId: String) async throws {
        let userInfo = try await self.authService.getUser(idAuth: userId)
        self.user = userInfo
        self.isConnected = user != nil
    }
    
    func clearSession() {
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
                guard let self else { return }
                Task { [weak self] in
                    guard let self else { return }
                    guard let userId = userId else {
                        self.clearSession()
                        return
                    }
                    try await self.updateUser(userId: userId)
                }
            }
            .store(in: &cancellables)
    }

    private func observeAppLifecycle() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationWillTerminate(_:)),
            name: UIApplication.willTerminateNotification,
            object: nil
        )
    }
    
    @objc private func applicationWillTerminate(_ notification: Notification) {
        Task { @MainActor in
            stopListeners()
        }
    }
}
