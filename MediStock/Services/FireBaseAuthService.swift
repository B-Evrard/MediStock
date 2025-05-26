//
//  AuthService.swift
//  MediStock
//
//  Created by Bruno Evrard on 22/05/2025.
//

import Foundation
import FirebaseAuth

class FireBaseAuthService: AuthProviding {
    private let auth: Auth
    private var handle: AuthStateDidChangeListenerHandle?
    private let userManager: UserManager
    private let storeService: DataStore
    
    init(auth: Auth  = Auth.auth(), userManager: UserManager, storeService: DataStore = FireBaseStoreService()) {
        self.auth = auth
        self.userManager = userManager
        self.storeService = storeService
    }
    
    func listen() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            guard user != nil else {
                Task { @MainActor in
                    self?.userManager.reset()
                }
                return
            }
        }
    }
    
    
    func signIn(withEmail email: String, password: String) async throws -> String? {
        _ = try await Auth.auth().signIn(withEmail: email, password: password)
        return auth.currentUser?.uid
    }
    
    func signUp(withEmail email: String, password: String) async throws  -> UserInfo?  {
        _ = try await Auth.auth().createUser(withEmail: email, password: password)
        let user = UserInfo(idAuth: auth.currentUser?.uid, displayName: "", email: email)
        return user
    }
    
    func signOut() async throws {
        try auth.signOut()
        Task { @MainActor in
            self.userManager.reset()
        }
    }
    
    func unbind() {
        if let handle = handle {
            auth.removeStateDidChangeListener(handle)
        }
    }
}
