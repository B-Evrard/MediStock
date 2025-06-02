//
//  HistoryService.swift
//  MediStock
//
//  Created by Bruno Evrard on 31/05/2025.
//

import Foundation

final class HistoryService {
    
    func generateHistory(userId: String, oldMedicine: MedicineViewData?, newMedicine: MedicineViewData?) -> HistoryEntry? {
        
        guard let oldMedicine = oldMedicine else {
            // ADD medicine
            guard let newMedicine = newMedicine else {
                return nil
            }
            let detail  = "Add medicine : Name : \(newMedicine.name) - Stock : \(newMedicine.stock) - Aisle : \(newMedicine.aisle?.label ?? "") "
            
            let entry = HistoryEntry(
                id:"",
                medicineId: newMedicine.id ?? "",
                userId: userId,
                action: HistoryAction.Add.rawValue,
                details: detail,
                timestamp: Date()
            )
            return entry
        }
        
        guard let newMedicine = newMedicine else {
            // DELETE medicine
            let detail  = "Delete medicine : Name : \(oldMedicine.name)"
            
            let entry = HistoryEntry(
                id:"",
                medicineId: oldMedicine.id ?? "",
                userId: userId,
                action: HistoryAction.Delete.rawValue,
                details: detail,
                timestamp: Date()
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
                id:"",
                medicineId: oldMedicine.id ?? "",
                userId: userId,
                action: HistoryAction.Update.rawValue,
                details: "Upddate medicine \(oldMedicine.name) : \(detail)",
                timestamp: Date()
            )
            return entry
        }
        return nil
    }
    
}
