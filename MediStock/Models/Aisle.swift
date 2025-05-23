//
//  Aisle.swift
//  MediStock
//
//  Created by Bruno Evrard on 22/05/2025.
//

import Foundation
import FirebaseFirestore

struct Aisle: Codable {
    @DocumentID var id: String?
    var aisleNumber: Int
}
