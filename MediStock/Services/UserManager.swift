//
//  UserManager.swift
//  MediStock
//
//  Created by Bruno Evrard on 21/05/2025.
//


import Foundation
import FirebaseAuth

class UserManager: ObservableObject {
    
    @Published var user: UserInfo?
    @Published var isConnected: Bool
    
    init() {
        self.isConnected = Auth.auth().currentUser != nil
    }
    
    func update(user: UserInfo?) {
        self.user = user
        self.isConnected = user != nil
    }
    
    func reset() {
        self.user = nil
        self.isConnected = false
    }
}
