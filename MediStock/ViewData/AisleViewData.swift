//
//  AisleViewData.swift
//  MediStock
//
//  Created by Bruno Evrard on 23/05/2025.
//

import Foundation

struct AisleViewData: Hashable, Decodable, Identifiable {
    var id: String?
    var name: String
    
    var label: String {
        return "Aisle \(name)"
    }
}
