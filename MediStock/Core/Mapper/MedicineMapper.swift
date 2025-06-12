//
//  MedicineMapper.swift
//  MediStock
//
//  Created by Bruno Evrard on 27/05/2025.
//

import Foundation

struct MedicineMapper {
    
    static func mapToViewData(_ medicine: MedicineModel, aisle: AisleModel?) -> MedicineViewData {
        return .init(
            id: medicine.id ?? "",
            name: medicine.name,
            stock: medicine.stock,
            aisle: AisleMapper.mapToViewData(aisle ?? AisleModel(id: "", name: "", nameSearch: "", sortKey: ""))
        )
    }
    
    static func mapToListViewData(_ medicine: MedicineModel) -> MedicineViewData {
        return .init(
            id: medicine.id ?? "",
            name: medicine.name,
            stock: medicine.stock,
            aisle: AisleViewData.init(id: medicine.aisleId)
        )
    }
    
    static func mapToModel(_ viewData: MedicineViewData) -> MedicineModel {
        return .init(
            id: viewData.id,
            aisleId: viewData.aisle?.id ?? "",
            name: viewData.name,
            stock: viewData.stock
        )
    }
}
