//
//  MedicineListViewModel.swift
//  MediStock
//
//  Created by Bruno Evrard on 03/06/2025.
//

import Foundation
import Combine

@MainActor
final class MedicineListViewModel: ObservableObject {
    
    // MARK: - Published
    @Published var medicines: [MedicineViewData] = []
    @Published var isError: Bool = false
    @Published var errorMessage: String = ""
    @Published var search: String = ""
    @Published var sortOption: SortOption = .name
    @Published var isLoading = false
    
    // MARK: - Public
    let aisleSelected: AisleViewData?
    
    // MARK: - Private
    private let session: SessionManager
    private let dataStoreService: DataStore
    private let historyService: HistoryService
    private var hasStartedListening = false
    private var streamTask: Task<Void, Never>?
    private var isInitialLoad = true
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(session: SessionManager, aisleSelected: AisleViewData? = nil) {
        self.session = session
        self.dataStoreService = session.storeService
        self.aisleSelected = aisleSelected
        self.historyService = HistoryService()
        
        $search
            .debounce(for: .seconds(0.8), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                guard let self = self else { return }
                    if self.isInitialLoad {
                        self.isInitialLoad = false
                        return
                    }
                    Task {
                        await self.refreshMedicines()
                    }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Methods
    func startListening() {
        guard !hasStartedListening else { return }
        hasStartedListening = true
        self.isError = false
        streamTask = Task { [weak self] in
            guard let self = self else { return }
            do {
                self.isLoading = true
                for try await medicineUpdate in dataStoreService.streamMedicines(aisleId: aisleSelected?.id ?? nil, filter: search, sortOption: sortOption) {
                    
                    if (!medicineUpdate.added.isEmpty)
                    {
                        self.medicines.append(contentsOf: medicineUpdate.added.map(MedicineMapper.mapToListViewData))
                    }
                    
                    if (!medicineUpdate.modified.isEmpty) {
                        for medicineData in medicineUpdate.modified {
                            let newMedViewData = MedicineMapper.mapToListViewData(medicineData)
                            if let index = self.medicines.firstIndex(where: { $0.id == medicineData.id }) {
                                self.medicines[index] = newMedViewData
                            }
                        }
                    }
                    
                    if (!medicineUpdate.removedIds.isEmpty) {
                        self.medicines.removeAll { medicineUpdate.removedIds.contains($0.id ?? "") }
                    }
                    /// On retrie la liste car en cas d'ajout detecter par le addSnapshotListener la liste n'est plus triée
                    switch sortOption {
                    case .name:
                        medicines.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
                    case .stock:
                        medicines.sort { $0.stock < $1.stock}
                    }
                    self.isError = false
                    self.isLoading = false
                }
            } catch {
                self.isError = true
                self.isLoading = false
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
        self.isError = false
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
