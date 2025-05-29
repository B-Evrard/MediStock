//
//  AuthService.swift
//  MediStock
//
//  Created by Bruno Evrard on 22/05/2025.
//

import Foundation
import FirebaseAuth

class FireBaseAuthService: AuthProviding , ObservableObject {
    private let auth: Auth
    private var handle: AuthStateDidChangeListenerHandle?
    @Published var userManager: UserManager
    private let storeService: DataStore
    
    init(auth: Auth  = Auth.auth(), userManager: UserManager = UserManager(), storeService: DataStore = FireBaseStoreService()) {
        self.auth = auth
        self.userManager = userManager
        self.storeService = storeService
        listen()
    }
    
    func updateUserManager(user: UserInfo?) {
        self.userManager.user = user
        self.userManager.isConnected = user != nil
    }
    
    func resetUserManager() {
        self.userManager.user = nil
        self.userManager.isConnected = false
    }
    
    func listen() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            DispatchQueue.main.async {
                if let firebaseUser = user {
                    guard let self = self else { return }
                    Task {
                        do {
                            let userId = firebaseUser.uid
                            let userInfo = try await self.storeService.getUser(idAuth: userId)
                            self.updateUserManager(user: userInfo)
                        } catch {
                            self.resetUserManager()
                        }
                    }
                } else {
                    self?.resetUserManager()
                }
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
        await MainActor.run {
            resetUserManager()
        }
    }
    
    func unbind() {
        if let handle = handle {
            auth.removeStateDidChangeListener(handle)
        }
    }
}
