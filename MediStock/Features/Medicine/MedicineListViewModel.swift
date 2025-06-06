//
//  MedicineListViewModel.swift
//  MediStock
//
//  Created by Bruno Evrard on 03/06/2025.
//

import Foundation

@MainActor
final class MedicineListViewModel: ObservableObject {
    
    // MARK: - Published
    @Published var medicines: [MedicineViewData] = []
    @Published var isError: Bool = false
    @Published var errorMessage: String = ""
    
    // MARK: - Public
    let aisleSelected: AisleViewData?
    
    // MARK: - Private
    private let session: SessionManager
    private let dataStoreService: DataStore
    private let historyService: HistoryService
    private var isLoading: Bool = false
    private var hasStartedListening = false
    private var streamTask: Task<Void, Never>?
    
    // MARK: - Init
    init(session: SessionManager, aisleSelected: AisleViewData? = nil) {
        self.session = session
        self.dataStoreService = session.storeService
        self.aisleSelected = aisleSelected
        self.historyService = HistoryService()
    }
    
    // MARK: - Methods
    func startListening() {
        guard !hasStartedListening else { return }
        hasStartedListening = true
        self.isError = false
        streamTask = Task { [weak self] in
            guard let self = self else { return }
            do {
                for try await medicineUpdate in dataStoreService.streamMedicines(aisleId: aisleSelected?.id ?? nil) {
                    
                    if (!medicineUpdate.added.isEmpty)
                    {
                        self.medicines.append(contentsOf: medicineUpdate.added.map(MedicineMapper.mapToListViewData))
                        print ("--------> added")
                    }
                    
                    if (!medicineUpdate.modified.isEmpty) {
                        for medicineData in medicineUpdate.modified {
                            let newMedViewData = MedicineMapper.mapToListViewData(medicineData)
                            if let index = self.medicines.firstIndex(where: { $0.id == medicineData.id }) {
                                self.medicines[index] = newMedViewData
                            }
                        }
                        print ("--------> modified")
                    }
                    
                    if (!medicineUpdate.removedIds.isEmpty) {
                        self.medicines.removeAll { medicineUpdate.removedIds.contains($0.id ?? "") }
                        print ("--------> removed")
                    }
                    /// On retrie la liste car en cas d'ajout detecter par le addSnapshotListener la liste n'est plus triée
                    medicines.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
                    self.isError = false
                }
            } catch {
                self.isError = true
            }
        }
    }
    
    func refreshMedicines() async {
        self.isError = false
        streamTask?.cancel()
        dataStoreService.resetStreamMedicines()
        self.medicines = []
        self.hasStartedListening = false
        self.startListening()
    }
    
    func deleteMedicine(medicine: MedicineViewData) async -> Bool{
        guard let user = session.user else {
            self.isError = true
            self.errorMessage = AppMessages.genericError
            return false
        }
        guard let id = medicine.id else {
            return false
        }
        do {
            try await dataStoreService.deleteMedicine(id: id)
            let historyEntry = historyService.generateHistory(user: user, oldMedicine: medicine, newMedicine: nil)
            if let historyEntry {
                _ = try await dataStoreService.addHistory(historyEntry)
            }
        } catch {
            self.isError = true
            self.errorMessage = AppMessages.genericError
            return false
        }
        return true
    }
    
}
