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
    init(session: SessionManager, storeService: DataStore = FireBaseStoreService(), aisleSelected: AisleViewData? = nil) {
        self.session = session
        self.dataStoreService = storeService
        self.aisleSelected = aisleSelected
        self.historyService = HistoryService()
        
        
        
        //        self.session.$isConnected
        //            .sink(receiveValue: { isLogged in
        //                print("toto \(isLogged)")
        //            })
        //            .store(in: &self.cancellables)
        
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
            guard let dataStoreService = self?.dataStoreService else { return }
            do {
                self?.isLoading = true
                
                for try await update in dataStoreService.streamMedicines(
                    
                    aisleId: self?.aisleSelected?.id ?? nil,
                    filter: self?.search,
                    sortOption: self?.sortOption
                ) {
                    
                    guard let self else { return }
                    var updatedList = self.medicines
                    
                    let added = update.added.map(MedicineMapper.mapToListViewData)
                    updatedList.append(contentsOf: added)
                    
                    for medData in update.modified {
                        let mapped = MedicineMapper.mapToListViewData(medData)
                        if let index = updatedList.firstIndex(where: { $0.id == medData.id }) {
                            updatedList[index] = mapped
                        }
                    }
                    
                    updatedList.removeAll { update.removedIds.contains($0.id ?? "") }
                    
                    switch self.sortOption {
                    case .name:
                        updatedList = updatedList.sorted {
                            $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
                        }
                    case .stock:
                        updatedList = updatedList.sorted { $0.stock < $1.stock }
                    }
                    
                    
                    self.medicines = updatedList
                    self.isLoading = false
                    self.isError = false
                }
            } catch {
                self?.isError = true
                self?.isLoading = false
            }
        }
    }
    
    func refreshMedicines() async {
        self.isError = false
        removeListener()
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
        if (medicine.isDeleteable) {
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
        } else {
            self.isError = true
            self.errorMessage = AppMessages.genericError
            return false
        }
        
    }
    
    func removeListener() {
        streamTask?.cancel()
        dataStoreService.resetStreamMedicines()
    }
    
}
