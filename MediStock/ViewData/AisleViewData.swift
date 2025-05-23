//
//  AisleViewData.swift
//  MediStock
//
//  Created by Bruno Evrard on 23/05/2025.
//

import Foundation

struct AisleViewData: Hashable, Decodable {
    var id: String?
    var aisleNumber: Int
    
    var label: String {
        return "Aisle \(aisleNumber)"
    }
}
