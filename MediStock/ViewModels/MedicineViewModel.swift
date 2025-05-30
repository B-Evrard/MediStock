//
//  MedicineViewModel.swift
//  MediStock
//
//  Created by Bruno Evrard on 27/05/2025.
//

import Foundation

final class MedicineViewModel: ObservableObject {
    
    private let session: any AuthProviding
    private let dataStoreService: DataStore
    private let aisleStreamingService: AisleStreamingService
   
    @Published var medicine : MedicineViewData
    @Published var aisles: [AisleViewData] = []
    
    @Published var showAddAisleSheet = false
    @Published var newAisle = AisleViewData.init(name: "")
    
    init(session: any AuthProviding, dataStoreService: DataStore = FireBaseStoreService(), medicine: MedicineViewData) {
        self.session = session
        self.dataStoreService = dataStoreService
        self.medicine = medicine
        self.aisleStreamingService = AisleStreamingService(dataStoreService: dataStoreService)
    }
    
    func startAisleStreamingListening() {
        aisleStreamingService.startListening { [weak self] newAisles in
            DispatchQueue.main.async {
                self?.aisles = newAisles
            }
        }
    }
    
    func stopAisleStreamingListening() {
        aisleStreamingService.stopListening()
    }
    
    private func initMedicine(medicine: MedicineViewData?) {
        if let medicine = medicine {
            //TODO: Charge Aisle
            self.medicine = medicine
        } else {
            self.medicine = MedicineViewData(id: "", aisleId: "", name: "", stock: 0)
        }
    }
    
}
