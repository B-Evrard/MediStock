//
//  UserViewModelTest.swift
//  MediStockTests
//
//  Created by Bruno Evrard on 15/06/2025.
//

import Foundation

import XCTest
@testable import MediStock

final class UserViewModelTest: XCTestCase {
    
    @MainActor
    func testInitFailsWhenUserIsNil() {
        let authService = MockFBAuthService()
        let session = SessionManager(authService: authService)
        let viewModel = UserViewModel(
            session: session
        )
        XCTAssertTrue(viewModel.isError)
    }
    
    @MainActor
    func testInitOk() {
        let authService = MockFBAuthService()
        let session = SessionManager(authService: authService)
        session.user = UserModel(idAuth: "123", displayName: "Bruno", email: "test@test.com")
        session.isConnected = true
        let viewModel = UserViewModel(
            session: session
        )
        XCTAssertFalse(viewModel.isError)
        
        XCTAssertEqual(viewModel.user?.displayName, "Bruno")
        XCTAssertEqual(viewModel.user?.email, "test@test.com")
        XCTAssertEqual(viewModel.user?.idAuth, "123")
    }
    
    @MainActor
    func testLogout() async {
        let authService = MockFBAuthService()
        let session = SessionManager(authService: authService)
        session.user = UserModel(idAuth: "123", displayName: "Bruno", email: "test@test.com")
        session.isConnected = true
        let viewModel = UserViewModel(
            session: session
        )
        XCTAssertFalse(viewModel.isError)
        await viewModel.logout()
        
        XCTAssertFalse(session.isConnected)
        XCTAssertNil(session.user)
    }
}
