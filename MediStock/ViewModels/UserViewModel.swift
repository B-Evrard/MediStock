//
//  AppViewModel.swift
//  MediStock
//
//  Created by Bruno Evrard on 26/05/2025.
//

import Foundation

@MainActor
final class UserViewModel: ObservableObject {
    
    private let authService: AuthProviding
    private let storeService: DataStore
    private var userManager: UserManager
    
    @Published var user: UserInfoViewData?
    @Published var error: String = ""
    
    init(authService: AuthProviding , storeService: DataStore = FireBaseStoreService(), userManager: UserManager) {
        self.authService = authService
        self.storeService = storeService
        self.userManager = userManager
        loadUser()
    }
    
    func logout() async {
        self.error = ""
        do {
            try await authService.signOut()
        } catch {
           self.error = AppMessages.genericError
        }
    }
    
    private func loadUser() {
        guard let user = userManager.user else { return }
        self.user = UserInfoMapper.mapToViewData(user)
    }
}
