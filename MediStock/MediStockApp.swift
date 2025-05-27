//
//  MediStockApp.swift
//  MediStock
//
//  Created by Vincent Saluzzo on 28/05/2024.
//

import SwiftUI
import FirebaseCore

@main
struct MediStockApp: App {
    //@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var authService: AuthProviding
    @StateObject private var userManager: UserManager
    init () {
        FirebaseApp.configure()
        self.userManager = UserManager()
        authService = FireBaseAuthService(userManager: userManager)
        authService.checkUserSession()
    }
    
    var body: some Scene {
        WindowGroup {
            if userManager.isConnected {
                MainTabView()
            } else {
                LoginView(viewModel: LoginViewModel(authService: FireBaseAuthService(userManager: userManager), userManager: userManager))
            }
        }
        .environmentObject(userManager)
    }
}
