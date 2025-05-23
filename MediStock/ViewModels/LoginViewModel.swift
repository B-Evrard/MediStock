//
//  LoginViewModel.swift
//  MediStock
//
//  Created by Bruno Evrard on 22/05/2025.
//

import Foundation

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
    
    init(authService: AuthProviding, storeService: DataStore, userManager: UserManager) {
        self.authService = authService
        self.storeService = storeService
        self.userManager = userManager
    }
    
    func signIn() {
        //self.authService.signIn(withEmail: email, password: password)
    }
    
    func signUp() {
        //self.authService.signUp(withEmail: email, password: password)
    }
    

    
    func initListen() {
        self.authService.listen()
    }
    
    
    
}
