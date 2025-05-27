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
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var userManager = UserManager()
    
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
