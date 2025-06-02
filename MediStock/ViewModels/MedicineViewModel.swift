//
//  MedicineViewModel.swift
//  MediStock
//
//  Created by Bruno Evrard on 27/05/2025.
//

import Foundation

@MainActor
final class MedicineViewModel: ObservableObject {
    
    private let session: any AuthProviding
    private let dataStoreService: DataStore
    private let historyService: HistoryService
    
    private let medicineBeforeUpdate: MedicineViewData?
    
    @Published var medicine : MedicineViewData
    @Published var aisles: [AisleViewData] = []
    @Published var searchText: String = "" {
        didSet {
            updateFilteredAisles()
        }
    }
    @Published var filteredAisles: [AisleViewData] = []
    
    @Published var showAddAisleSheet = false
    @Published var newAisle = AisleViewData.init(name: "")
    
    @Published var isError: Bool = false
    @Published var errorMessage: String = ""
    
    
    
    init(session: any AuthProviding, dataStoreService: DataStore = FireBaseStoreService(), medicine: MedicineViewData = MedicineViewData.init()) {
        self.session = session
        self.dataStoreService = dataStoreService
        self.medicine = medicine
        self.historyService = HistoryService()
        self.medicineBeforeUpdate = medicine
    }
    
    func checkAilseSelected(aisleSelected: AisleViewData) -> Bool{
        guard let aisle = medicine.aisle else {
           return false
        }
        return aisleSelected.id == aisle.id
    }
    
    func fetchAisles() async {
        do {
            let aislesData = try await dataStoreService.fetchAisles()
            self.aisles = aislesData.map(AisleMapper.mapToViewData)
            
        } catch {
            self.isError = true
        }
    }
    
    func updateFilteredAisles() {
        let lowercased = searchText.lowercased()
        filteredAisles = aisles.filter {
            $0.name.lowercased().contains(lowercased)
        }
    }
    
    func AddAisle() async {
        self.isError = false
        do {
            let newAisle = Aisle(name: self.searchText, nameSearch: self.searchText.removingAccentsUppercased, sortKey: self.searchText.normalizedSortKey)
            let aisle = try await dataStoreService.addAisle(newAisle)
            self.medicine.aisle = AisleMapper.mapToViewData(aisle)
            self.searchText = ""
            await self.fetchAisles()
        } catch {
            self.isError = true
            print("Error adding aisle")
        }
    }
    
    func aisleExist() -> Bool {
        return aisles.contains(where: { $0.name.uppercased() == self.searchText.uppercased() })
    }
    
    func validate() async -> Bool {
        self.isError = false
        self.errorMessage = ""
        do {
            guard let userId = session.user?.idAuth else {
                self.isError = true
                self.errorMessage = AppMessages.genericError
                return false
            }
            var historyEntry: HistoryEntry?
            try Control.controleMedicine(medicine: medicine)
            let medicineModel = MedicineMapper.mapToModel(self.medicine)
            if medicineModel.id != nil {
                try await dataStoreService.updateMedicine(medicineModel)
                historyEntry = historyService.generateHistory(userId: userId, oldMedicine: medicineBeforeUpdate, newMedicine: medicine)
            } else {
                let newMedicine = try await dataStoreService.addMedicine(medicineModel)
                medicine.id = newMedicine.id
                historyEntry = historyService.generateHistory(userId: userId, oldMedicine: nil, newMedicine: medicine)
            }
            guard let historyEntry else {
                self.isError = true
                self.errorMessage = AppMessages.genericError
                return false
            }
            _ = try await dataStoreService.addHistory(historyEntry)
            return true
        } catch {
            self.isError = true
            self.errorMessage = AppMessages.genericError
            return false
        }
    }
    
}
