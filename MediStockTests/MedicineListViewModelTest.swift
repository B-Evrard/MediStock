//
//  MedicineListViewModelTest.swift
//  MediStockTests
//
//  Created by Bruno Evrard on 10/06/2025.
//

import XCTest
@testable import MediStock

final class MedicineListViewModelTest: XCTestCase {


    @MainActor
    func testStartListeningFail() async {
        let authService = MockFBAuthService()
        let storeService = MockFBStoreService()
        storeService.shouldSucceed = false
        let session = SessionManager(storeService: storeService, authService: authService)
        
        let viewModel = MedicineListViewModel(
            session: session
        )
        
        viewModel.startListening()
        try? await Task.sleep(for: .seconds(3))
        XCTAssertTrue(viewModel.isError)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    @MainActor
    func testStartListeningOK() async {
        let authService = MockFBAuthService()
        let storeService = MockFBStoreService()
        var expectedUpdate = MedicineUpdate(
                    added: [Medicine(id: "1", aisleId: "1", name: "Paracetamol", stock: 100),
                           Medicine(id: "2", aisleId: "2", name: "Ibuprofen", stock: 200),
                            Medicine(id: "3", aisleId: "3", name: "Doliprane", stock: 300)],
                    modified: [],
                    removedIds: []
                )
        storeService.medicineUpdates = expectedUpdate
        let session = SessionManager(storeService: storeService, authService: authService)
        
        let viewModel = MedicineListViewModel(
            session: session
        )
        
        viewModel.startListening()
        try? await Task.sleep(for: .seconds(2))
        
        storeService.send(update: expectedUpdate)
        
        try? await Task.sleep(for: .seconds(3))
        XCTAssertFalse(viewModel.isError)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.medicines.count, 3)
        if (viewModel.medicines.count > 0) {
            XCTAssertEqual(viewModel.medicines[0].id, "3")
            XCTAssertEqual(viewModel.medicines[0].stock, 300)
        }
        
        expectedUpdate = MedicineUpdate(
                    added: [],
                    modified: [Medicine(id: "3", aisleId: "3", name: "Doliprane", stock: 500)],
                    removedIds: []
                )
        
        try? await Task.sleep(for: .seconds(2))
        storeService.send(update: expectedUpdate)
        try? await Task.sleep(for: .seconds(3))
        
        XCTAssertEqual(viewModel.medicines.count, 3)
        XCTAssertEqual(viewModel.medicines[0].stock, 500)
    }
}
