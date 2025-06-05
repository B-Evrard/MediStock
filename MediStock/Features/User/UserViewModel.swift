//
//  AppViewModel.swift
//  MediStock
//
//  Created by Bruno Evrard on 26/05/2025.
//

import Foundation

@MainActor
final class UserViewModel: ObservableObject {
    
    private let session: any AuthProviding
    private let storeService: DataStore
    
    
    @Published var user: UserInfoViewData?
    @Published var error: String = ""
    
    init(session: any AuthProviding , storeService: DataStore = FireBaseStoreService()) {
        self.session = session
        self.storeService = storeService
        loadUser()
    }
    
    func logout() async {
        self.error = ""
        do {
            try await session.signOut()
        } catch {
           self.error = AppMessages.genericError
        }
    }
    
    private func loadUser() {
        guard let user = session.user else { return }
        self.user = UserInfoMapper.mapToViewData(user)
    }
}
