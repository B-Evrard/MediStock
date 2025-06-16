//
//  LoginViewModelTest.swift
//  MediStock
//
//  Created by Bruno Evrard on 10/06/2025.
//

import XCTest
@testable import MediStock

final class LoginViewModelTest: XCTestCase {
    
    @MainActor
    func testLoginFail() async {
        
        let authService = MockFBAuthService()
        let session = SessionManager(authService: authService)
        
        let viewModel = LoginViewModel(
            session: session
        )
        
        viewModel.email = ""
        viewModel.password = ""
        var isLogged = await viewModel.signIn()
        XCTAssertFalse(isLogged)
        XCTAssertEqual(viewModel.message, AppMessages.emailEmpty)
        
        viewModel.email = "hhhh"
        isLogged = await viewModel.signIn()
        XCTAssertFalse(isLogged)
        XCTAssertEqual(viewModel.message, AppMessages.invalidFormatMail)
        
        viewModel.email = "be@be.fr"
        isLogged = await viewModel.signIn()
        XCTAssertFalse(isLogged)
        XCTAssertEqual(viewModel.message, AppMessages.passwordEmpty)
        
        viewModel.email = "be@be.fr"
        viewModel.password = "password"
        isLogged = await viewModel.signIn()
        XCTAssertFalse(isLogged)
        XCTAssertEqual(viewModel.message, AppMessages.loginFailed)
        
    }
    
    @MainActor
    func testLoginAuthServiceFail() async {
        
        let authService = MockFBAuthService()
        authService.userExist = false
        
        let session = SessionManager(authService: authService)
        
        let viewModel = LoginViewModel(
            session: session
        )
        
        let mockUser = MockProvider.mockUser
        viewModel.email = mockUser.email
        viewModel.password = "password"
        let isLogged = await viewModel.signIn()
        XCTAssertFalse(isLogged)
        XCTAssertEqual(viewModel.message, AppMessages.genericError)
        
    }
    
    @MainActor
    func testLoginFBUSerFail() async {

        let authService = MockFBAuthService()
        authService.shouldSucceed = false
        let session = SessionManager(authService: authService)
        
        let viewModel = LoginViewModel(
            session: session
        )
        
        let mockUser = MockProvider.mockUser
        viewModel.email = mockUser.email
        viewModel.password = "password"
        let isLogged = await viewModel.signIn()
        XCTAssertFalse(isLogged)
        XCTAssertEqual(viewModel.message, AppMessages.genericError)
    }
    
    
    @MainActor
    func testLoginOk() async {
        
        let authService = MockFBAuthService()
        let session = SessionManager(authService: authService)
        
        let viewModel = LoginViewModel(
            session: session
        )
        
        let mockUser = MockProvider.mockUser
        viewModel.email = mockUser.email
        viewModel.password = "password"
        let isLogged = await viewModel.signIn()
        XCTAssertTrue(isLogged)
        
        XCTAssertTrue(session.isConnected)
        XCTAssertEqual(session.user?.idAuth, mockUser.idAuth)
        XCTAssertEqual(session.user?.email, mockUser.email)
        XCTAssertEqual(session.user?.displayName, mockUser.displayName)
        
    }
    
    @MainActor
    func testSignUpFail() async {
        
        let authService = MockFBAuthService()
        let session = SessionManager(authService: authService)
        
        let viewModel = LoginViewModel(
            session: session
        )
        
        viewModel.email = ""
        viewModel.password = ""
        viewModel.confirmedPassword = ""
        viewModel.name = ""
        
        var isLogged = await viewModel.signUp()
        XCTAssertFalse(isLogged)
        XCTAssertEqual(viewModel.message, AppMessages.emailEmpty)
        
        viewModel.email = "hhhh"
        isLogged = await viewModel.signUp()
        XCTAssertFalse(isLogged)
        XCTAssertEqual(viewModel.message, AppMessages.invalidFormatMail)
        
        viewModel.email = "be@be.fr"
        isLogged = await viewModel.signUp()
        XCTAssertFalse(isLogged)
        XCTAssertEqual(viewModel.message, AppMessages.passwordEmpty)
        
        viewModel.email = "be@be.fr"
        viewModel.password = "password"
        isLogged = await viewModel.signUp()
        XCTAssertFalse(isLogged)
        XCTAssertEqual(viewModel.message, AppMessages.invalidPassword)
        
        viewModel.email = "be@be.fr"
        viewModel.password = "Bruno220865&"
        viewModel.confirmedPassword = ""
        isLogged = await viewModel.signUp()
        XCTAssertFalse(isLogged)
        XCTAssertEqual(viewModel.message, AppMessages.passwordNotMatch)
        
        viewModel.email = "be@be.fr"
        viewModel.password = "Bruno220865&"
        viewModel.confirmedPassword = "Bruno220865&"
        isLogged = await viewModel.signUp()
        XCTAssertFalse(isLogged)
        XCTAssertEqual(viewModel.message, AppMessages.nameEmpty)
        
        let mockUser = MockProvider.mockUser
        viewModel.email = mockUser.email
        viewModel.password = "Bruno220865&"
        viewModel.confirmedPassword = "Bruno220865&"
        viewModel.name = mockUser.displayName
        
        isLogged = await viewModel.signUp()
        XCTAssertFalse(isLogged)
        XCTAssertEqual(viewModel.message, AppMessages.emailAlreadyExists)
    }
    
    @MainActor
    func testSignUpAuthServiceFail() async {
        
        let authService = MockFBAuthService()
        authService.signUpValid = false
        let session = SessionManager(authService: authService)
        
        let viewModel = LoginViewModel(
            session: session
        )
        viewModel.email = "be@be.fr"
        viewModel.password = "Bruno220865&"
        viewModel.confirmedPassword = "Bruno220865&"
        viewModel.name = "Bruno"
        
        let isLogged = await viewModel.signUp()
        XCTAssertFalse(isLogged)
        XCTAssertEqual(viewModel.message, AppMessages.genericError)
        
    }
    
    @MainActor
    func testSignUpOk() async {
        
        let authService = MockFBAuthService()
        let session = SessionManager(authService: authService)
        
        let viewModel = LoginViewModel(
            session: session
        )
        
        viewModel.email = "be@be.fr"
        viewModel.password = "Bruno220865&"
        viewModel.confirmedPassword = "Bruno220865&"
        viewModel.name = "Bruno"
        
        let isLogged = await viewModel.signUp()
        
        XCTAssertTrue(isLogged)
        XCTAssertTrue(session.isConnected)
        XCTAssertEqual(session.user?.email, "be@be.fr")
        XCTAssertEqual(session.user?.displayName, "Bruno")
        
    }
}
