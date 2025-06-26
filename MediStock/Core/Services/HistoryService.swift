//
//  HistoryService.swift
//  MediStock
//
//  Created by Bruno Evrard on 31/05/2025.
//

import Foundation

final class HistoryService {
    
    func generateHistory(user: UserModel, oldMedicine: MedicineViewData?, newMedicine: MedicineViewData?) -> HistoryEntryModel? {
        
        guard oldMedicine != nil || newMedicine != nil else { return nil }
        
        // ADD medicine
        if oldMedicine == nil, let newMedicine {
            let detail = "Stock: \(newMedicine.stock) - Aisle: \(newMedicine.aisle?.label ?? "")"
            return makeEntry(
                id: newMedicine.id ?? "",
                action: .Add,
                details: detail,
                user: user
            )
        }
        
        // DELETE medicine
        if newMedicine == nil, let oldMedicine {
            let detail = "\(oldMedicine.name) - Aisle: \(oldMedicine.aisle?.label ?? "")"
            return makeEntry(
                id: oldMedicine.id ?? "",
                action: .Delete,
                details: detail,
                user: user
            )
        }
        
        // MODIFIY
        guard let old = oldMedicine, let new = newMedicine else { return nil }

        var changes: [String] = []

        if old.name != new.name {
            changes.append("Rename: \(new.name)")
        }

        if old.stock != new.stock {
            changes.append("Stock: \(old.stock) → \(new.stock)")
        }

        if old.aisle?.label != new.aisle?.label {
            changes.append("Aisle: \(old.aisle?.label ?? "") → \(new.aisle?.label ?? "")")
        }

        guard !changes.isEmpty else { return nil }

        return makeEntry(
            id: old.id ?? "",
            action: .Update,
            details: changes.joined(separator: " - "),
            user: user
        )
    }
    
    private func makeEntry(
        id: String,
        action: HistoryAction,
        details: String,
        user: UserModel
    ) -> HistoryEntryModel {
        return HistoryEntryModel(
            medicineId: id,
            action: action.rawValue,
            details: details,
            modifiedAt: Date(),
            modifiedByUserId: user.idAuth ?? "",
            modifiedByUserName: user.displayName
        )
    }
}
