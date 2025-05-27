//
//  MedicineViewModel.swift
//  MediStock
//
//  Created by Bruno Evrard on 27/05/2025.
//

import Foundation

final class MedicineViewModel: ObservableObject {
    
    private let storeService: DataStore
    private var userManager: UserManager
    @Published var medicine : MedicineViewData?
    
    init(storeService: DataStore = FireBaseStoreService(), userManager: UserManager, medicine: MedicineViewData? = nil) {
        self.storeService = storeService
        self.userManager = userManager
        initMedicine(medicine: medicine)
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
