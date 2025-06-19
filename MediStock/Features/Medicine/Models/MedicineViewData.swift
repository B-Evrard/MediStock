//
//  MedicineViewData.swift
//  MediStock
//
//  Created by Bruno Evrard on 27/05/2025.
//

import Foundation

struct MedicineViewData: Hashable, Identifiable {
    var id: String?
    var name: String
    var stock: Int
    var aisle: AisleViewData?
    var history: [HistoryEntryViewData]?
    
    init(id: String? = nil, name: String = "", stock: Int = 0, aisle: AisleViewData? = nil, history: [HistoryEntryViewData]? = nil) {
        self.id = id
        self.name = name
        self.stock = stock
        self.aisle = aisle
        self.history = history
    }
    
    var isDeleteable: Bool {
        return stock == 0
    }
}
