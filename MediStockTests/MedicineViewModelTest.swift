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
    
        let viewModel = await makeInitializedViewModel(shouldSucceed: false)
        XCTAssertTrue(viewModel.isErrorInit)
        XCTAssertFalse(viewModel.isError)
        XCTAssertTrue(viewModel.isAlertPresented)
        XCTAssertEqual(viewModel.aisles.count, 0)
    }
    
    @MainActor
    func testInitMedicineAddOk() async {
        
        let viewModel = await makeInitializedViewModel()
        XCTAssertFalse(viewModel.isErrorInit)
        XCTAssertFalse(viewModel.isError)
        XCTAssertFalse(viewModel.isAlertPresented)
        XCTAssertEqual(viewModel.aisles.count, 10)
        
    }
    
    @MainActor
    func testInitMedicineUpdateFail() async {
        
        let medicine = MedicineMapper.mapToViewData(
            MockProvider.generateMedicines()[0],
            aisle: MockProvider.generateAisles()[0]
        )
        let viewModel = await makeInitializedViewModel(shouldSucceed: false, medicine: medicine)
        XCTAssertTrue(viewModel.isErrorInit)
        XCTAssertFalse(viewModel.isError)
        XCTAssertTrue(viewModel.isAlertPresented)
        XCTAssertEqual(viewModel.aisles.count, 0)
    }
    
    @MainActor
    func testInitMedicineUpdateOk() async {
        
        let medicine = MedicineMapper.mapToViewData(
            MockProvider.generateMedicines()[0],
            aisle: MockProvider.generateAisles()[0]
        )
        let viewModel = await makeInitializedViewModel(medicine: medicine)
        XCTAssertFalse(viewModel.isErrorInit)
        XCTAssertFalse(viewModel.isError)
        XCTAssertFalse(viewModel.isAlertPresented)
        XCTAssertEqual(viewModel.aisles.count, 10)
        XCTAssertEqual(viewModel.medicine.history?.count, 5)
    }
    
    @MainActor
    func testUpdateFilteredAisles() async {
        
        let viewModel = await makeInitializedViewModel()
        XCTAssertFalse(viewModel.isErrorInit)
        XCTAssertFalse(viewModel.isError)
        XCTAssertFalse(viewModel.isAlertPresented)
        XCTAssertEqual(viewModel.aisles.count, 10)
        
        viewModel.searchAisle = "1"
        XCTAssertEqual(viewModel.filteredAisles.count, 2)
    }
    
    
    @MainActor
    func testAddAisleFail() async {
        let authService = MockFBAuthService()
        let storeService = MockFBStoreService()
        let session = SessionManager(authService: authService)
        
        let viewModel = MedicineViewModel(
            session: session,
            medicine: MedicineViewData(),
            storeService: storeService
        )
        
        await viewModel.initMedicine()
        XCTAssertFalse(viewModel.isError)
        XCTAssertEqual(viewModel.aisles.count, 10)
        
        viewModel.searchAisle = "new 1"
        XCTAssertEqual(viewModel.filteredAisles.count, 0)
        
        storeService.shouldSucceed = false
        await viewModel.addAisle()
        
        XCTAssertTrue(viewModel.isError)
        XCTAssertFalse(viewModel.isErrorInit)
        XCTAssertTrue(viewModel.isAlertPresented)
        XCTAssertEqual(viewModel.errorMessage, AppMessages.genericError)
        XCTAssertEqual(viewModel.aisles.count, 10)
        viewModel.searchAisle = "new 1"
        XCTAssertEqual(viewModel.filteredAisles.count, 0)
    }
    
    
    @MainActor
    func testAddAisle() async {
        let viewModel = await makeInitializedViewModel()
        XCTAssertFalse(viewModel.isErrorInit)
        XCTAssertFalse(viewModel.isError)
        XCTAssertFalse(viewModel.isAlertPresented)
        XCTAssertEqual(viewModel.aisles.count, 10)
        
        viewModel.searchAisle = "new 1"
        XCTAssertEqual(viewModel.filteredAisles.count, 0)
        await viewModel.addAisle()
        XCTAssertEqual(viewModel.aisles.count, 11)
        viewModel.searchAisle = "new 1"
        XCTAssertEqual(viewModel.filteredAisles.count, 1)
    }
    
    @MainActor
    func testAisleExists() async {
        
        let viewModel = await makeInitializedViewModel()
        
        viewModel.searchAisle = "1"
        XCTAssertTrue(viewModel.aisleExist())
        
        viewModel.searchAisle = "1*"
        XCTAssertFalse(viewModel.aisleExist())
        
    }

    
    @MainActor
    func testValidateFailControl() async {
        
        let viewModel = await makeInitializedViewModel()
        
        _ = await viewModel.validate()
        XCTAssertTrue(viewModel.isError)
        XCTAssertEqual(viewModel.errorMessage, AppMessages.medicineNameEmpty)
        
        viewModel.medicine.name = "Test"
        _ = await viewModel.validate()
        XCTAssertTrue(viewModel.isError)
        XCTAssertFalse(viewModel.isErrorInit)
        XCTAssertTrue(viewModel.isAlertPresented)
        XCTAssertEqual(viewModel.errorMessage, AppMessages.aisleEmpty)
        
    }
    
    @MainActor
    func testAddMedicineFailsIfAlreadyExists() async {
    
        let viewModel = await makeInitializedViewModel()
        //MedicineModel(id: "1", aisleId: "1", name: "Paracetamol", stock: 100),
        viewModel.medicine.name = "Paracetamol"
        viewModel.medicine.aisle = viewModel.aisles.first(where: { $0.id == "1" })
        _ = await viewModel.validate()
        XCTAssertTrue(viewModel.isError)
        XCTAssertFalse(viewModel.isErrorInit)
        XCTAssertTrue(viewModel.isAlertPresented)
        XCTAssertEqual(viewModel.errorMessage, AppMessages.medicineExist)
        
    }
    
    @MainActor
    func testValidationFailsWhenDatabaseUpdateFails() async {
    
        let authService = MockFBAuthService()
        let storeService = MockFBStoreService()
        let session = SessionManager(authService: authService)
        session.user = UserModel(idAuth: "123", displayName: "Bruno", email: "test@test.com")
        session.isConnected = true
        let viewModel = MedicineViewModel(
            session: session,
            medicine: MedicineViewData(),
            storeService: storeService
        )
        await viewModel.initMedicine()
        viewModel.medicine.name = "TestNewMedicine"
        viewModel.medicine.aisle = viewModel.aisles.first(where: { $0.id == "1" })
        storeService.shouldSucceed = false
        _ = await viewModel.validate()
        XCTAssertTrue(viewModel.isError)
        XCTAssertFalse(viewModel.isErrorInit)
        XCTAssertTrue(viewModel.isAlertPresented)
        XCTAssertEqual(viewModel.errorMessage, AppMessages.genericError)
        
    }
    
    @MainActor
    func testValidationAddOk() async {
        let viewModel = await makeInitializedViewModel()
        viewModel.medicine.name = "TestNewMedicine"
        viewModel.medicine.aisle = viewModel.aisles.first(where: { $0.id == "1" })
        _ = await viewModel.validate()
        XCTAssertFalse(viewModel.isError)
        XCTAssertFalse(viewModel.isErrorInit)
        XCTAssertFalse(viewModel.isAlertPresented)
        XCTAssertNotNil(viewModel.medicine.id)
    }
    
    @MainActor
    func testValidationUpdateOk() async {
        guard let medicine = MockProvider.generateMedicines().first else {
            XCTFail()
            return
        }
        guard let aisle = MockProvider.generateAisles().first(where: { $0.id == "2" })  else {
            XCTFail()
            return
        }
        let aisleData = AisleMapper.mapToViewData(aisle)
        let medicineViewData = MedicineMapper.mapToViewData(medicine, aisle: nil)
        let viewModel = await makeInitializedViewModel(medicine: medicineViewData)
        viewModel.medicine.name = "TestUpdateMedicine"
        viewModel.medicine.aisle = aisleData
        viewModel.medicine.stock = 110
        _ = await viewModel.validate()
        XCTAssertFalse(viewModel.isError)
        XCTAssertFalse(viewModel.isErrorInit)
        XCTAssertFalse(viewModel.isAlertPresented)
    }
    
    @MainActor
    func makeInitializedViewModel(shouldSucceed: Bool = true, medicine: MedicineViewData = MedicineViewData()) async -> MedicineViewModel {
        
        let authService = MockFBAuthService()
        let storeService = MockFBStoreService()
        storeService.shouldSucceed = shouldSucceed
        let session = SessionManager(authService: authService)
        session.user = UserModel(idAuth: "123", displayName: "Bruno", email: "test@test.com")
        session.isConnected = true
        let viewModel = MedicineViewModel(
            session: session,
            medicine: medicine,
            storeService: storeService
        )
        
        await viewModel.initMedicine()
        return viewModel
    }
}
