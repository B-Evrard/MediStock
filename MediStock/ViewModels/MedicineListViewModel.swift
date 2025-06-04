//
//  MedicineListViewModel.swift
//  MediStock
//
//  Created by Bruno Evrard on 03/06/2025.
//

import Foundation

@MainActor
final class MedicineListViewModel: ObservableObject {
    private let dataStoreService: DataStore
    private let aisleSelected: AisleViewData?
    
    @Published var medicines: [MedicineViewData] = []
    @Published var isError: Bool = false
    
    private var isLoading: Bool = false
    
    private var streamTask: Task<Void, Never>?
    
    init(dataStoreService: DataStore = FireBaseStoreService(), aisleSelected: AisleViewData? = nil) {
        self.dataStoreService = dataStoreService
        self.aisleSelected = aisleSelected
    }
    
    func startListening() {
        self.isError = false
        streamTask = Task { [weak self] in
            guard let self = self else { return }
            do {
                for try await batch in dataStoreService.streamMedicines(aisleId: aisleSelected?.id ?? nil) {
                    for newMed in batch {
                        let newMedViewData = MedicineMapper.mapToListViewData(newMed)
                        if let index = self.medicines.firstIndex(where: { $0.id == newMed.id }) {
                            self.medicines[index] = newMedViewData
                        } else {
                            self.medicines.append(newMedViewData)
                        }
                    }
                    /// On retrie la liste car en cas d'ajout detecter par le addSnapshotListener la liste n'est
                    /// plus triée
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
        medicines = []
        self.startListening()
    }
    
}
