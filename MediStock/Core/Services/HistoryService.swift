//
//  HistoryService.swift
//  MediStock
//
//  Created by Bruno Evrard on 31/05/2025.
//

import Foundation

final class HistoryService {
    
    /// Génère une entrée d'historique en fonction des changements apportés à un médicament.
    ///
    /// Cette méthode compare deux états d'un médicament (`oldMedicine` et `newMedicine`) pour déterminer
    /// s'il s'agit d'une création, suppression ou modification, et produit une entrée d'historique adaptée.
    ///
    /// - Parameters:
    ///   - user: L'utilisateur ayant effectué l'action.
    ///   - oldMedicine: L'état précédent du médicament (optionnel).
    ///   - newMedicine: Le nouvel état du médicament (optionnel).
    ///
    /// - Returns: Une `HistoryEntryModel` décrivant l'action, ou `nil` si aucun changement pertinent n’est détecté.
    ///
    /// - Cas traités :
    ///   - **Ajout** : `oldMedicine == nil` et `newMedicine != nil` → action `.Add`
    ///   - **Suppression** : `newMedicine == nil` et `oldMedicine != nil` → action `.Delete`
    ///   - **Modification** : les deux non-nuls, comparaison des champs `name`, `stock`, `aisle`
    ///     → action `.Update` si au moins un champ a changé.
    ///
    /// - Remarques:
    ///   - Retourne `nil` si les deux paramètres sont `nil` ou s’il n’y a aucun changement détecté.
    ///   - Les détails de l’action sont formatés en texte lisible (ex. : "Stock: 5 → 8 - Aisle: Réserve → Frigo").
    ///   - L’identifiant utilisé est celui du médicament concerné.
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
