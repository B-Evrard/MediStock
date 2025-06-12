//
//  MedicineViewModelTest.swift
//  MediStockTests
//
//  Created by Bruno Evrard on 12/06/2025.
//

import XCTest
@testable import MediStock

final class MedicineViewModelTest: XCTestCase {
    
    @MainActor
    func testInitMedicineAddFail() async {
        
        let authService = MockFBAuthService()
        let storeService = MockFBStoreService()
        storeService.shouldSucceed = false
        let session = SessionManager(authService: authService)
        
        let viewModel = MedicineViewModel(
            session: session,
            medicine: MedicineViewData(),
            storeService: storeService
        )
        
        await viewModel.initMedicine()
        XCTAssertTrue(viewModel.isErrorInit)
        XCTAssertEqual(viewModel.aisles.count, 0)
    }
    
    @MainActor
    func testInitMedicineAddOk() async {
        
        let authService = MockFBAuthService()
        let storeService = MockFBStoreService()
        let session = SessionManager(authService: authService)
        
        let viewModel = MedicineViewModel(
            session: session,
            medicine: MedicineViewData(),
            storeService: storeService
        )
        
        await viewModel.initMedicine()
        XCTAssertFalse(viewModel.isErrorInit)
        XCTAssertEqual(viewModel.aisles.count, 10)
        
    }
    
    @MainActor
    func testInitMedicineUpdateFail() async {
        
        let authService = MockFBAuthService()
        let storeService = MockFBStoreService()
        storeService.shouldSucceed = false
        let session = SessionManager(authService: authService)
        
        let medicine = MedicineMapper.mapToViewData(
            MockProvider.getMockMedicines()[0],
            aisle: MockProvider.generateAisles()[0]
        )
        
        let viewModel = MedicineViewModel(
            session: session,
            medicine: medicine,
            storeService: storeService
        )
        
        await viewModel.initMedicine()
        XCTAssertTrue(viewModel.isErrorInit)
        XCTAssertEqual(viewModel.aisles.count, 0)
    }
    
    @MainActor
    func testInitMedicineUpdateOk() async {
        
        let authService = MockFBAuthService()
        let storeService = MockFBStoreService()
        let session = SessionManager(authService: authService)
        
        let medicine = MedicineMapper.mapToViewData(
            MockProvider.getMockMedicines()[0],
            aisle: MockProvider.generateAisles()[0]
        )
        
        let viewModel = MedicineViewModel(
            session: session,
            medicine: medicine,
            storeService: storeService
        )
        
        await viewModel.initMedicine()
        XCTAssertFalse(viewModel.isErrorInit)
        XCTAssertEqual(viewModel.aisles.count, 10)
        XCTAssertEqual(viewModel.medicine.history?.count, 5)
    }
    
}
