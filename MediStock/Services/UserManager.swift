//
//  UserManager.swift
//  MediStock
//
//  Created by Bruno Evrard on 21/05/2025.
//


import Foundation

class UserManager: ObservableObject {
    
    @Published var user: UserInfo?
    @Published var isConnected: Bool = false
    
    func update(user: UserInfo?) {
        self.user = user
        self.isConnected = user != nil
    }
    
    func reset() {
        self.user = nil
        self.isConnected = false
    }
    
//    func checkUserSession() {
//        if let currentUser = Auth.auth().currentUser {
//            Task {
//                let userInfo = try await storeService.getUser(id: currentUser.uid)
//                await MainActor.run {
//                    self.update(user: userInfo)
//                }
//            }
//        } else {
//            self.reset()
//        }
//    }
}
