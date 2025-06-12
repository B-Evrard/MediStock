//
//  AisleListViewModelTest.swift
//  MediStockTests
//
//  Created by Bruno Evrard on 10/06/2025.
//

import XCTest
@testable import MediStock

final class AisleListViewModelTest: XCTestCase {
    
    @MainActor
    func testFetchAislesFail() async {
        
        let authService = MockFBAuthService()
        let storeService = MockFBStoreService()
        storeService.shouldSucceed = false
        let session = SessionManager(authService: authService)
        
        let viewModel = AisleListViewModel(
            session: session,
            storeService: storeService
        )
        
        await viewModel.fetchAisles()
        
        XCTAssertTrue(viewModel.isError)
        XCTAssertFalse(viewModel.isLoading)
        
        XCTAssertEqual(viewModel.aisles.count, 0)
        
    }
    
    @MainActor
    func testFetchAislesOk() async {
        
        let authService = MockFBAuthService()
        let storeService = MockFBStoreService()
        let session = SessionManager(authService: authService)
        
        let viewModel = AisleListViewModel(
            session: session,
            storeService: storeService
        )
        
        await viewModel.fetchAisles()
        
        XCTAssertFalse(viewModel.isError)
        XCTAssertFalse(viewModel.isLoading)
        
        XCTAssertEqual(viewModel.aisles.count, 10)
        
    }
}
