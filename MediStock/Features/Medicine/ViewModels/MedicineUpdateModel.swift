//
//  MedicineUpdate.swift
//  MediStock
//
//  Created by Bruno Evrard on 05/06/2025.
//

import Foundation

struct MedicineUpdateModel {
    var added: [MedicineModel]
    var modified: [MedicineModel]
    var removedIds: [String]
    
    init(added: [MedicineModel] = [], modified: [MedicineModel] = [], removedIds: [String] = []) {
        self.added = added
        self.modified = modified
        self.removedIds = removedIds
    }
}
