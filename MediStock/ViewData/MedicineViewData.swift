//
//  MedicineViewData.swift
//  MediStock
//
//  Created by Bruno Evrard on 27/05/2025.
//

import Foundation

struct MedicineViewData {
    var id: String?
    var name: String
    var stock: Int
    var aisle: AisleViewData?
    
    init(id: String? = nil, name: String = "", stock: Int = 0, aisle: AisleViewData? = nil) {
            self.id = id
            self.name = name
            self.stock = stock
            self.aisle = aisle
        }
}
