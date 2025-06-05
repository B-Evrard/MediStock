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
    
    private var medicineBeforeUpdate: MedicineViewData? = nil
    
    @Published var medicine : MedicineViewData
    @Published var aisles: [AisleViewData] = []
    @Published var searchText: String = "" {
        didSet {
            updateFilteredAisles()
        }
    }
    @Published var filteredAisles: [AisleViewData] = []
    
    @Published var showAddAisleSheet = false
    @Published var newAisle = AisleViewData.init(id: nil, name: "")
    
    @Published var isError: Bool = false
    @Published var errorMessage: String = ""
    
    //private var onSave: ((MedicineViewData) -> Void)?
    
    init(
        session: any AuthProviding,
        dataStoreService: DataStore = FireBaseStoreService(),
        medicine: MedicineViewData = MedicineViewData.init(),
        onSave: ((MedicineViewData) -> Void)? = nil
    ) {
        self.session = session
        self.dataStoreService = dataStoreService
        self.medicine = medicine
        self.historyService = HistoryService()
        //self.onSave = onSave
    }
    
    func initMedicine() async {
        await fetchAisles()
        guard let medicineId = medicine.id else {
            return
        }
        do
        {
            let medicineData = try await dataStoreService.getMedicine(id: medicineId)
            let aisleData = try await dataStoreService.getAisle(id: medicineData.aisleId)
            self.medicine = MedicineMapper.mapToViewData(medicineData, aisle: aisleData)
            self.medicineBeforeUpdate = medicine
            let historyEntries = try await dataStoreService.fetchHistory(medicineId: medicineId)
            medicine.history = historyEntries.map { HistoryEntryViewData(historyEntry: $0) }
        } catch {
            self.isError = true
            self.errorMessage = AppMessages.genericError
        }
    }
    
    func checkAilseSelected(aisleSelected: AisleViewData) -> Bool{
        guard let aisle = medicine.aisle else {
           return false
        }
        return aisleSelected.id == aisle.id
    }
    
    private func fetchAisles() async {
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
            guard let user = session.user else {
                self.isError = true
                self.errorMessage = AppMessages.genericError
                return false
            }
            var historyEntry: HistoryEntry?
            try Control.controleMedicine(medicine: medicine)
            let medicineModel = MedicineMapper.mapToModel(self.medicine)
            if medicineModel.id != nil {
                try await dataStoreService.updateMedicine(medicineModel)
                historyEntry = historyService.generateHistory(user: user, oldMedicine: medicineBeforeUpdate, newMedicine: medicine)
            } else {
                let isMedicineExist = try await dataStoreService.medicineExistByNameAndAisle(name: medicine.name, aisleId: medicine.aisle?.id ?? "")
                if isMedicineExist {
                    self.isError = true
                    self.errorMessage = AppMessages.medicineExist
                    return false
                }
                let newMedicine = try await dataStoreService.addMedicine(medicineModel)
                medicine.id = newMedicine.id
                historyEntry = historyService.generateHistory(user: user, oldMedicine: nil, newMedicine: medicine)
            }
            if let historyEntry {
                _ = try await dataStoreService.addHistory(historyEntry)
            }
            return true
        } catch let error as ControlError {
            self.isError = true
            self.errorMessage = error.message
            return false
        } catch {
            self.isError = true
            self.errorMessage = AppMessages.genericError
            return false
        }
    }
    
}
