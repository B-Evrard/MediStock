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
    private var userManager: UserManager

    init(authService: AuthProviding , storeService: DataStore = FireBaseStoreService(), userManager: UserManager) {
        self.authService = authService
        self.storeService = storeService
        self.userManager = userManager
    }
    
    func signIn() async -> Bool{
        self.message = ""
        do {
            try Control.signIn(email: email, password: password)
            let id = try await authService.signIn(withEmail: email, password: password)
            
            guard let id = id else {
                message = AppMessages.genericError
                return false
            }
            //let user = try await storeService.getUser(idAuth: id)
            //userManager.update(user: user)
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
                print (error.localizedDescription)
                message = AppMessages.genericError
                return false
            }
           
        }
        
        return true
        
    }
    
    func signUp() async -> Bool {
        self.message = ""
        do {
            try Control.signUp(email: email, password: password, confirmedPassword: confirmedPassword, name: name)
            let user = try await authService.signUp(withEmail: email, password: password)
            guard var user = user else {
                message = AppMessages.genericError
                return false
            }
            user.displayName = name
            try await storeService.addUser(user)
            userManager.update(user: user)
            
        } catch let error as ControlError {
            message = error.message
            return false
        } catch let error as NSError {
            switch error.code {
            case AuthErrorCode.emailAlreadyInUse.rawValue:
                self.message = AppMessages.emailAlreadyExists
                return false
            default:
                self.message = AppMessages.genericError
                return false
            }
        } catch {
            message = AppMessages.genericError
            return false
        }
        return true
    }
    
    func initListen() {
        self.authService.listen()
    }
    
    
    
}
