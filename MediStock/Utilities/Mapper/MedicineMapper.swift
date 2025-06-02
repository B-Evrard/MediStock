//
//  MedicineMapper.swift
//  MediStock
//
//  Created by Bruno Evrard on 27/05/2025.
//

import Foundation

struct MedicineMapper {
    
    static func mapToViewData(_ medicine: Medicine, aisle: Aisle?) -> MedicineViewData {
        return .init(
            id: medicine.id ?? "",
            name: medicine.name,
            stock: medicine.stock,
            aisle: AisleMapper.mapToViewData(aisle ?? Aisle(id: "", name: "", nameSearch: "", sortKey: ""))
        )
    }
    
    static func mapToModel(_ viewData: MedicineViewData) -> Medicine {
        return .init(
            id: viewData.id,
            aisleId: viewData.aisle?.id ?? "",
            name: viewData.name,
            stock: viewData.stock
        )
    }
}
