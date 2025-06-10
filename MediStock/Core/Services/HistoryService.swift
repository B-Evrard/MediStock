//
//  HistoryService.swift
//  MediStock
//
//  Created by Bruno Evrard on 31/05/2025.
//

import Foundation

final class HistoryService {
    
    func generateHistory(user: MediStockUser, oldMedicine: MedicineViewData?, newMedicine: MedicineViewData?) -> HistoryEntry? {
        
        guard let oldMedicine = oldMedicine else {
            // ADD medicine
            guard let newMedicine = newMedicine else {
                return nil
            }
            let detail  = "Stock : \(newMedicine.stock) - Aisle : \(newMedicine.aisle?.label ?? "") "
            
            let entry = HistoryEntry(
                medicineId: newMedicine.id ?? "",
                action: HistoryAction.Add.rawValue,
                details: detail,
                modifiedAt: Date(),
                modifiedByUserId: user.idAuth ?? "",
                modifiedByUserName: user.displayName
            )
            return entry
        }
        
        guard let newMedicine = newMedicine else {
            // DELETE medicine
            let detail  = "\(oldMedicine.name) - Aisle : \(oldMedicine.aisle?.label ?? "") "
            
            let entry = HistoryEntry(
                medicineId: oldMedicine.id ?? "",
                action: HistoryAction.Delete.rawValue,
                details: detail,
                modifiedAt: Date(),
                modifiedByUserId: user.idAuth ?? "",
                modifiedByUserName: user.displayName
            )
            return entry
        }
        
        // MODIFIY
        var isModified: Bool = false
        var detail = ""
        if (oldMedicine.name != newMedicine.name) {
            detail += "Rename : \(newMedicine.name)"
            isModified = true
        }
        
        if (oldMedicine.stock != newMedicine.stock) {
            detail += detail.isEmpty ? "" : " - "
            detail += "Stock : \(oldMedicine.stock) --> \(newMedicine.stock)"
            isModified = true
        }
        
        if (oldMedicine.aisle?.label != newMedicine.aisle?.label) {
            detail += detail.isEmpty ? "" : " - "
            detail += "Aisle : \(oldMedicine.aisle?.label ?? "") --> \(newMedicine.aisle?.label ?? "")"
            isModified = true
        }
        if (isModified) {
            let entry = HistoryEntry(
                medicineId: oldMedicine.id ?? "",
                action: HistoryAction.Update.rawValue,
                details: detail,
                modifiedAt: Date(),
                modifiedByUserId: user.idAuth ?? "",
                modifiedByUserName: user.displayName
            )
            return entry
        }
        return nil
    }
}
