//
//  AuthService.swift
//  MediStock
//
//  Created by Bruno Evrard on 22/05/2025.
//

import Foundation
import FirebaseAuth
import Combine

class FireBaseAuthService: AuthProviding  {
    
    
    private let auth: Auth
    private var handle: AuthStateDidChangeListenerHandle?
    var userIdPublisher = PassthroughSubject<String?, Never>()
    
    init(auth: Auth  = Auth.auth() ) {
        self.auth = auth
        //listen()
    }
    
//    func updateUser(user: UserInfo?) {
//        self.user = user
//        self.isConnected = user != nil
//    }
//    
//    func resetUser() {
//        self.user = nil
//        self.isConnected = false
//    }
    
//    func listen() -> {
//        handle = auth.addStateDidChangeListener { [weak self] (auth, user) in
//            DispatchQueue.main.async {
//                if let firebaseUser = user {
//                    guard let self = self else { return }
//                    //Task {
//                        //do {
//                            return firebaseUser.uid
//                            //let userInfo = try await self.storeService.getUser(idAuth: userId)
//                            //self.updateUser(user: userInfo)
//                        //} catch {
//                            //self.resetUser()
//                        //}
//                    //}
//                } else {
//                    //self?.resetUser()
//                }
//            }
//        }
//    }
    
    func listen() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            self?.userIdPublisher.send(user?.uid)
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
    
//    func signOut() async throws {
//        try auth.signOut()
//        await MainActor.run {
//            resetUser()
//        }
//    }
    
    func unbind() {
        if let handle = handle {
            auth.removeStateDidChangeListener(handle)
        }
    }
}
