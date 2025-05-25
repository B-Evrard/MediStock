//
//  LoginViewModel.swift
//  MediStock
//
//  Created by Bruno Evrard on 22/05/2025.
//

import Foundation
import FirebaseAuth

@MainActor
class LoginViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmedPassword  = ""
    @Published var name  = ""
    @Published var message: String = ""
    
    
    private let authService: AuthProviding
    private let storeService: DataStore

    init(authService: AuthProviding , storeService: DataStore = FireStoreService()) {
        self.authService = authService
        self.storeService = storeService
    }
    
    func signIn() async -> Bool{
        self.message = ""
        do {
            try Control.signIn(email: email, password: password)
            let id = try await authService.signIn(withEmail: email, password: password)
            guard id != nil else {
                message = AppMessages.genericError
                return false
            }
        } catch let error as ControlError {
            message = error.message
            return false
        } catch  let error as NSError {
            if let errorCode = AuthErrorCode(rawValue: error.code) {
                switch errorCode {
                case .invalidCredential, .wrongPassword, .userNotFound:
                    message = AppMessages.loginFailed
                default:
                    message = AppMessages.genericError
                }
                return false
            } else {
                message = AppMessages.genericError
                return false
            }
           
        }
        
        return true
        
    }
    
    func signUp() {
        //self.authService.signUp(withEmail: email, password: password)
    }
    
    func initListen() {
        self.authService.listen()
    }
    
    
    
}
