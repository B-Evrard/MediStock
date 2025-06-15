//
//  AppViewModel.swift
//  MediStock
//
//  Created by Bruno Evrard on 26/05/2025.
//

import Foundation

@MainActor
final class UserViewModel: ObservableObject {
    
    // MARK: - Published
    @Published var user: UserViewData?
    @Published var isError: Bool = false
    
    // MARK: - Public
    
    // MARK: - Private
    private let session: SessionManager
    
    // MARK: - Init
    init(session: SessionManager) {
        self.session = session
        loadUser()
    }
    
    // MARK: - Public methods
    func logout() async {
        self.isError = false
        do {
            try await session.signOut()
        } catch {
            self.isError = true
        }
    }
    
    
    // MARK: - Private Methods
    private func loadUser() {
        guard let user = session.user else {
            isError = true
            return
        }
        self.user = MediStockUserInfoMapper.mapToViewData(user)
    }
}
