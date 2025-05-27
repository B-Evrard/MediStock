//
//  RootViewModel.swift
//  MediStock
//
//  Created by Bruno Evrard on 27/05/2025.
//

import Foundation

class RootViewModel: ObservableObject {
    private let authService: AuthProviding
    
    init(authService: AuthProviding) {
        self.authService = authService
    }
    
    func checkUserSession() async {
        do {
            try await authService.checkUserSession()
        } catch {
            print(error)
        }
        
    }
}
