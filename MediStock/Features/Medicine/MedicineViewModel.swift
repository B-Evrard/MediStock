//
//  MedicineViewModel.swift
//  MediStock
//
//  Created by Bruno Evrard on 27/05/2025.
//

import Foundation

@MainActor
final class MedicineViewModel: ObservableObject {
    
    // MARK: - Published
    @Published var medicine : MedicineViewData
    @Published var aisles: [AisleViewData] = []
    @Published var searchAisle: String = "" {
        didSet {
            updateFilteredAisles()
        }
    }
    @Published var filteredAisles: [AisleViewData] = []
    @Published var showAddAisleSheet = false
    @Published var newAisle = AisleViewData.init(id: nil, name: "")
    @Published var isError: Bool = false
    @Published var errorMessage: String = ""
    
    // MARK: - Public
    
    // MARK: - Private
    private let session: SessionManager
    private let dataStoreService: DataStore
    private let historyService: HistoryService
    private var medicineBeforeUpdate: MedicineViewData? = nil

    // MARK: - Init
    init(
        session: SessionManager,
        medicine: MedicineViewData = MedicineViewData.init(),
        storeService: DataStore = FireBaseStoreService()
    ) {
        self.session = session
        self.dataStoreService = storeService
        self.medicine = medicine
        self.historyService = HistoryService()
    }
    
    // MARK: - Public methods
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
    
//    func checkAilseSelected(aisleSelected: AisleViewData) -> Bool{
//        guard let aisle = medicine.aisle else {
//           return false
//        }
//        return aisleSelected.id == aisle.id
//    }
    
    func updateFilteredAisles() {
        let lowercased = searchAisle.lowercased()
        filteredAisles = aisles.filter {
            $0.name.lowercased().contains(lowercased)
        }
    }
    
    func AddAisle() async {
        self.isError = false
        do {
            let newAisle = Aisle(name: self.searchAisle, nameSearch: self.searchAisle.removingAccentsUppercased, sortKey: self.searchAisle.normalizedSortKey)
            let aisle = try await dataStoreService.addAisle(newAisle)
            self.medicine.aisle = AisleMapper.mapToViewData(aisle)
            self.searchAisle = ""
            await self.fetchAisles()
        } catch {
            self.isError = true
            print("Error adding aisle")
        }
    }
    
    func aisleExist() -> Bool {
        return aisles.contains(where: { $0.name.uppercased() == self.searchAisle.uppercased() })
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
        
    // MARK: - Private Methods
    private func fetchAisles() async {
        do {
            let aislesData = try await dataStoreService.fetchAisles()
            self.aisles = aislesData.map(AisleMapper.mapToViewData)
         } catch {
            self.isError = true
        }
    }
    
}
