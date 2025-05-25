//
//  AuthService.swift
//  MediStock
//
//  Created by Bruno Evrard on 22/05/2025.
//

import Foundation
import Firebase

class AuthService: AuthProviding {
    private let auth: Auth
    private var handle: AuthStateDidChangeListenerHandle?
    private let userManager: UserManager

    init(auth: Auth  = Auth.auth(), userManager: UserManager) {
        self.auth = auth
        self.userManager = userManager  
    }

    func listen() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if user != nil {
                self?.userManager.isConnected = true
            } else {
                self?.userManager.reset()
            }
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws -> UserInfo? {
        _ = try await Auth.auth().signIn(withEmail: email, password: password)
        let user = UserInfo(id: auth.currentUser?.uid, displayName: "", email: email)
        return user
    }
    
    func signUp(withEmail email: String, password: String) async throws  -> UserInfo?  {
        _ = try await Auth.auth().createUser(withEmail: email, password: password)
        let user = UserInfo(id: auth.currentUser?.uid, displayName: "", email: email)
        return user
    }

    func signOut() async throws {
        try auth.signOut()
        userManager.reset()
    }

    func unbind() {
        if let handle = handle {
            auth.removeStateDidChangeListener(handle)
        }
    }
}
