//
//  MedicineViewData.swift
//  MediStock
//
//  Created by Bruno Evrard on 27/05/2025.
//

import Foundation

struct MedicineViewData {
    var id: String
    var aisleId: String
    var name: String
    var stock: Int
    
    var aisle: AisleViewData? {
        didSet {
            aisleId = aisle?.id ?? ""
        }
    }
    
    init(id: String = "", aisleId: String = "", name: String = "", stock: Int = 0, aisle: AisleViewData? = nil) {
            self.id = id
            self.aisleId = aisleId
            self.name = name
            self.stock = stock
            self.aisle = aisle
        }
}
