//
//  UserModel.swift
//  MediStock
//
//  Created by Bruno Evrard on 22/05/2025.
//

import Foundation
import FirebaseFirestore

struct UserModel: Codable {
    var idAuth: String?
    var displayName: String
    var email: String
}
