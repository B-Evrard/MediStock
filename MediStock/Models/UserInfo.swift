//
//  UserInfo.swift
//  MediStock
//
//  Created by Bruno Evrard on 22/05/2025.
//

import Foundation
import FirebaseFirestore

struct UserInfo: Codable {
    @DocumentID var id: String?
    var displayName: String
    var email: String
}
