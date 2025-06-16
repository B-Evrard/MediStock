//
//  AuthService.swift
//  MediStock
//
//  Created by Bruno Evrard on 22/05/2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

class FireBaseAuthService: AuthProviding  {
    let db = Firestore.firestore()

    // MARK: - Public
    var userIdPublisher = PassthroughSubject<String?, Never>()
    
    // MARK: - Private
    private let auth: Auth
    private var handle: AuthStateDidChangeListenerHandle?
    
    // MARK: - Init
    init(auth: Auth  = Auth.auth() ) {
        self.auth = auth
    }

    // MARK: - Methods
    func listen() {
        handle = auth.addStateDidChangeListener { [weak self] auth, user in
            self?.userIdPublisher.send(user?.uid)
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws -> String? {
        _ = try await auth.signIn(withEmail: email, password: password)
        return auth.currentUser?.uid
    }
    
    func signUp(withEmail email: String, password: String) async throws  -> UserModel?  {
        _ = try await auth.createUser(withEmail: email, password: password)
        let user = UserModel(idAuth: auth.currentUser?.uid, displayName: "", email: email)
        return user
    }
    
    func signOut() async throws {
        try auth.signOut()
    }
    
    func isConnected()  -> Bool {
        return auth.currentUser != nil
    }
    
    func removeListener() {
        if let handle = handle {
            auth.removeStateDidChangeListener(handle)
        }
    }
    
    // MARK: User
    func addUser(_ user: UserModel) async throws {
        _ = try db.collection("Users").addDocument(from: user)
    }
    
    func getUser(idAuth: String) async throws -> UserModel? {
        var user: UserModel?
        let FBUsers = db.collection("Users")
        let snapshot = try await FBUsers.whereField("idAuth", isEqualTo: idAuth).getDocuments()
        if (!snapshot.isEmpty) {
            user = try snapshot.documents[0].data(as : UserModel.self)
        }
        return user
    }
}
