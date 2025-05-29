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
    @Published var isConnected: Bool = false
    
    init() {
        //self.isConnected = Auth.auth().currentUser != nil
    }
}
