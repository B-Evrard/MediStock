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
    var isConnectedValue: Bool = false
    var mockUserUID: String? = "mock_uid_123"
    var usersValid = MockUsers.mockUsers
    
    let userIdPublisher = PassthroughSubject<String?, Never>()
    
    private var isListening = false
   
    func isConnected() -> Bool {
        return isConnectedValue
    }
    
    func listen() {
        isListening = true
        
        // Simule une connexion
        //mockAuth.simulateAuthChange(userId: "12345")

        // Simule une déconnexion
        //mockAuth.simulateAuthChange(userId: nil)<#code#>
    }
    
    func simulateAuthChange(userId: String?) {
        userIdPublisher.send(userId)
    }
    
    func signIn(withEmail email: String, password: String) async throws -> String? {
        if shouldSucceed {
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
    
    func signUp(withEmail email: String, password: String) async throws -> MediStockUser? {
        if shouldSucceed {
            if usersValid.first(where: { $0.email == email }) != nil {
                throw AuthErrorCode.emailAlreadyInUse
            }
            else {
                let user = MediStockUser(idAuth: UUID().uuidString, displayName: "", email: email)
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
    
    
}
