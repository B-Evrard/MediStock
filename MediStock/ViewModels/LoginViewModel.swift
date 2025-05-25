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

    init(authService: AuthProviding , storeService: DataStore = FireStoreService()) {
        self.authService = authService
        self.storeService = storeService
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
