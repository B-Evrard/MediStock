//
//  AisleMapper.swift
//  MediStock
//
//  Created by Bruno Evrard on 23/05/2025.
//

import Foundation

struct AisleMapper {
    
    static func mapToViewData(_ aisle: Aisle) -> AisleViewData {
        return AisleViewData(
            id: aisle.id,
            aisleNumber: aisle.aisleNumber
        )
    }
    
    static func mapToModel(_ viewData: AisleViewData) -> Aisle {
        return Aisle(
            id: viewData.id,
            aisleNumber: viewData.aisleNumber
        )
    }
    
}
