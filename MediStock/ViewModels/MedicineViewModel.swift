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
    
    
    
    init(session: any AuthProviding, dataStoreService: DataStore = FireBaseStoreService(), medicine: MedicineViewData = MedicineViewData.init()) {
        self.session = session
        self.dataStoreService = dataStoreService
        self.medicine = medicine
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
            $0.label.lowercased().contains(lowercased)
        }
    }
    
}
