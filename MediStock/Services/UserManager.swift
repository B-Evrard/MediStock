//
//  UserManager.swift
//  MediStock
//
//  Created by Bruno Evrard on 21/05/2025.
//


import Foundation

class UserManager: ObservableObject {
    
    @Published var currentUser: User?
    @Published var isLogged: Bool = false
}
