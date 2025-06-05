//
//  AuthService.swift
//  MediStock
//
//  Created by Bruno Evrard on 22/05/2025.
//

import Foundation
import FirebaseAuth
import Combine

class FireBaseAuthService: AuthProviding , ObservableObject {
    
    @Published var user: UserInfo?
    @Published var isConnected: Bool
    
    private let auth: Auth
    private var handle: AuthStateDidChangeListenerHandle?
    private let storeService: DataStore
    
    init(auth: Auth  = Auth.auth(), storeService: DataStore = FireBaseStoreService()) {
        self.auth = auth
        self.user = nil
        self.storeService = storeService
        self.isConnected = auth.currentUser != nil
        listen()
    }
    
    func updateUser(user: UserInfo?) {
        self.user = user
        self.isConnected = user != nil
    }
    
    func resetUser() {
        self.user = nil
        self.isConnected = false
    }
    
    func listen() {
        handle = auth.addStateDidChangeListener { [weak self] (auth, user) in
            DispatchQueue.main.async {
                if let firebaseUser = user {
                    guard let self = self else { return }
                    Task {
                        do {
                            let userId = firebaseUser.uid
                            let userInfo = try await self.storeService.getUser(idAuth: userId)
                            self.updateUser(user: userInfo)
                        } catch {
                            self.resetUser()
                        }
                    }
                } else {
                    self?.resetUser()
                }
            }
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws -> String? {
        _ = try await auth.signIn(withEmail: email, password: password)
        return auth.currentUser?.uid
    }
    
    func signUp(withEmail email: String, password: String) async throws  -> UserInfo?  {
        _ = try await auth.createUser(withEmail: email, password: password)
        let user = UserInfo(idAuth: auth.currentUser?.uid, displayName: "", email: email)
        return user
    }
    
    func signOut() async throws {
        try auth.signOut()
        await MainActor.run {
            resetUser()
        }
    }
    
    func unbind() {
        if let handle = handle {
            auth.removeStateDidChangeListener(handle)
        }
    }
}
