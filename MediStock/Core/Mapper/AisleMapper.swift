//
//  AisleMapper.swift
//  MediStock
//
//  Created by Bruno Evrard on 23/05/2025.
//

import Foundation

struct AisleMapper {
    
    static func mapToViewData(_ aisle: AisleModel) -> AisleViewData {
        return AisleViewData(
            id: aisle.id,
            name: aisle.name
        )
    }
    
    static func mapToModel(_ viewData: AisleViewData) -> AisleModel {
        return AisleModel(
            id: viewData.id,
            name: viewData.name,
            nameSearch: viewData.name.removingAccentsUppercased,
            sortKey: viewData.name.normalizedSortKey
        )
    }
}
