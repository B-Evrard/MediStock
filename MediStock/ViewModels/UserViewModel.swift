//
//  AppViewModel.swift
//  MediStock
//
//  Created by Bruno Evrard on 26/05/2025.
//

import Foundation

@MainActor
final class UserViewModel: ObservableObject {
    
    private let authService: any AuthProviding
    private let storeService: DataStore
    
    
    @Published var user: UserInfoViewData?
    @Published var error: String = ""
    
    init(authService: any AuthProviding , storeService: DataStore = FireBaseStoreService()) {
        self.authService = authService
        self.storeService = storeService
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
        guard let user = authService.userManager.user else { return }
        self.user = UserInfoMapper.mapToViewData(user)
    }
}
