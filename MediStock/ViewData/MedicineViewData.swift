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
    
    var aisle: AisleViewData?
    
}
