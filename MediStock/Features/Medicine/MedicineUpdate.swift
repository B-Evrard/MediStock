//
//  MedicineUpdate.swift
//  MediStock
//
//  Created by Bruno Evrard on 05/06/2025.
//

import Foundation

struct MedicineUpdate {
    var added: [Medicine]
    var modified: [Medicine]
    var removedIds: [String]
    
    init(added: [Medicine] = [], modified: [Medicine] = [], removedIds: [String] = []) {
        self.added = added
        self.modified = modified
        self.removedIds = removedIds
    }
}
