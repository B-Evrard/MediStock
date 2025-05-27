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
            if let firebaseUser = user {
                guard let self = self else { return }
                Task {
                    do {
                        let userId = firebaseUser.uid
                        let userInfo = try await self.storeService.getUser(idAuth: userId)
                        await MainActor.run {
                            self.userManager.update(user: userInfo)
                        }
                    } catch {
                        await MainActor.run {
                            self.userManager.reset()
                        }
                    }
                }
            } else {
                self?.userManager.reset()
            }
        }
    }
    
    func checkUserSession() async throws {
        
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
