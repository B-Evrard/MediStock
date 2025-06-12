//
//  MockFBAuthService.swift
//  MediStock
//
//  Created by Bruno Evrard on 10/06/2025.
//


import Foundation

@testable import MediStock
import FirebaseAuth
import Combine

class MockFBAuthService: AuthProviding {
    
    var shouldSucceed: Bool = true
    var userExist: Bool = true
    var signUpValid: Bool = true
    var isConnectedValue: Bool = false
    var mockUserUID: String? = "mock_uid_123"
    var usersValid = MockProvider.mockUsers
    
    let userIdPublisher = PassthroughSubject<String?, Never>()
    let mockError = NSError(domain: "MockFBStoreService", code: 1, userInfo: nil)
    
    private var isListening = false
   
    func isConnected() -> Bool {
        return isConnectedValue
    }
    
    func listen() {
        isListening = true
    }
    
    func simulateAuthChange(userId: String?) {
        userIdPublisher.send(userId)
    }
    
    func signIn(withEmail email: String, password: String) async throws -> String? {
        if userExist {
            if let user = usersValid.first(where: { $0.email == email }) {
                return user.idAuth
            }
            else {
                throw AuthErrorCode.invalidCredential
            }
        }
        else
        {
            return nil
        }
        
    }
    
    func signUp(withEmail email: String, password: String) async throws -> UserModel? {
        if signUpValid {
            if usersValid.first(where: { $0.email == email }) != nil {
                throw AuthErrorCode.emailAlreadyInUse
            }
            else {
                let user = UserModel(idAuth: UUID().uuidString, displayName: "", email: email)
                return user
            }
        } else {
            return nil
        }
    }
    
    func signOut() async throws {
        self.isConnectedValue = false
        userIdPublisher.send(nil)
    }
    
    func removeListener() {
        
    }
    
    func addUser(_ user: UserModel) async throws {
        let newUser = user
        usersValid.append(newUser)
    }
    
    func getUser(idAuth: String) async throws -> UserModel? {
        if shouldSucceed {
            if let foundUser = usersValid.first(where: { $0.idAuth == idAuth }) {
                return foundUser
            } else {
                throw mockError
            }
        } else {
            throw mockError
        }
    }
    
}
