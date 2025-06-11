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
        
        storeService.sendError()
        try? await Task.sleep(for: .seconds(3))
        XCTAssertTrue(viewModel.isError)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    @MainActor
    func testStartListeningOK() async {
        let authService = MockFBAuthService()
        let storeService = MockFBStoreService()
        let session = SessionManager(storeService: storeService, authService: authService)
        
        let viewModel = MedicineListViewModel(
            session: session
        )
        
        viewModel.startListening()
        try? await Task.sleep(for: .seconds(2))
        XCTAssertFalse(viewModel.isError)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.medicines.count, 20)
        
        //Medicine(id: "7", aisleId: "5", name: "Actifed", stock: 130)
        if (viewModel.medicines.count > 0) {
            XCTAssertEqual(viewModel.medicines[0].id, "7")
        }
        
        var expectedUpdate = MedicineUpdate(
            added: [Medicine(id: "21", aisleId: "1", name: "aa", stock: 100),
                    Medicine(id: "22", aisleId: "2", name: "bb", stock: 200),
                    Medicine(id: "23", aisleId: "3", name: "cc", stock: 300)],
            modified: [],
            removedIds: []
        )
        storeService.send(update: expectedUpdate)
        try? await Task.sleep(for: .seconds(3))
        XCTAssertFalse(viewModel.isError)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.medicines.count, 23)
        if (viewModel.medicines.count > 0) {
            XCTAssertEqual(viewModel.medicines[0].id, "21")
        }
        
        expectedUpdate = MedicineUpdate(
            added: [],
            modified: [Medicine(id: "7", aisleId: "5", name: "Actifed", stock: 200)],
            removedIds: []
        )
        storeService.send(update: expectedUpdate)
        try? await Task.sleep(for: .seconds(3))
        XCTAssertEqual(viewModel.medicines.count, 23)
        XCTAssertEqual(viewModel.medicines[1].id, "7")
        XCTAssertEqual(viewModel.medicines[1].stock, 200)
        
        expectedUpdate = MedicineUpdate(
            added: [],
            modified: [],
            removedIds: ["7"]
        )
        storeService.send(update: expectedUpdate)
        try? await Task.sleep(for: .seconds(3))
        XCTAssertEqual(viewModel.medicines.count, 22)
    }
    
    
    @MainActor
    func testSortByStock() async {
        let authService = MockFBAuthService()
        let storeService = MockFBStoreService()
        let session = SessionManager(storeService: storeService, authService: authService)
        
        let viewModel = MedicineListViewModel(
            session: session
        )
        
        viewModel.startListening()
        try? await Task.sleep(for: .seconds(2))
        XCTAssertFalse(viewModel.isError)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.medicines.count, 20)
        
        //Medicine(id: "7", aisleId: "5", name: "Actifed", stock: 130)
        if (viewModel.medicines.count > 0) {
            XCTAssertEqual(viewModel.medicines[0].id, "7")
        }
        
        viewModel.sortOption = .stock
        await viewModel.refreshMedicines()
        try? await Task.sleep(for: .seconds(2))
        XCTAssertFalse(viewModel.isError)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.medicines.count, 20)
        //Medicine(id: "15", aisleId: "9", name: "Clarix", stock: 40)
        if (viewModel.medicines.count > 0) {
            XCTAssertEqual(viewModel.medicines[0].id, "15")
        }
    }
    
        @MainActor
    func testSearch() async {
        let authService = MockFBAuthService()
        let storeService = MockFBStoreService()
        let session = SessionManager(storeService: storeService, authService: authService)
        
        let viewModel = MedicineListViewModel(
            session: session
        )
        
        viewModel.startListening()
        try? await Task.sleep(for: .seconds(2))
        
        XCTAssertFalse(viewModel.isError)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.medicines.count, 20)
        if (viewModel.medicines.count > 0) {
            XCTAssertEqual(viewModel.medicines[0].id, "7")
        }
        
        viewModel.search = "a"
        
    }
    
    @MainActor
    func testDelete() async {
        let authService = MockFBAuthService()
        let storeService = MockFBStoreService()
        let session = SessionManager(storeService: storeService, authService: authService)
        session.user = MediStockUser(idAuth: "123", displayName: "Bruno", email: "test@test.com")
        session.isConnected = true
        let viewModel = MedicineListViewModel(
            session: session
        )
        
        viewModel.startListening()
        try? await Task.sleep(for: .seconds(2))
        
        XCTAssertFalse(viewModel.isError)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.medicines.count, 20)
        
        var medicineToDelete = viewModel.medicines[0]
        if medicineToDelete.isDeleteable {
            await deleteMedicine(viewModel, medicineToDelete)
            XCTAssertFalse(viewModel.isError)
            XCTAssertFalse(viewModel.isLoading)
            XCTAssertEqual(viewModel.medicines.count, 19)
        } else {
            XCTAssertFalse(viewModel.isError)
            XCTAssertFalse(viewModel.isLoading)
            XCTAssertEqual(viewModel.medicines.count, 20)
            
            medicineToDelete.stock = 0
            XCTAssertTrue(medicineToDelete.isDeleteable)
            await deleteMedicine(viewModel, medicineToDelete)
            
            XCTAssertFalse(viewModel.isError)
            XCTAssertFalse(viewModel.isLoading)
            XCTAssertEqual(viewModel.medicines.count, 19)
        }
        
    }
    
    
    
    @MainActor
    private func deleteMedicine(_ viewModel: MedicineListViewModel, _ medicineToDelete: MedicineViewData) async {
        _ = await viewModel.deleteMedicine(medicine: medicineToDelete)
        try? await Task.sleep(for: .seconds(3))
    }
    
    
}
