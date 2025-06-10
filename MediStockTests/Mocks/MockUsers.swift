//
//  MockUsers.swift
//  MediStock
//
//  Created by Bruno Evrard on 10/06/2025.
//

import Foundation
@testable import MediStock

final class MockUsers {
    static let mockUser = MediStockUser(
        idAuth: "user_1",
        displayName: "Alice Johnson",
        email: "alice.johnson@example.com",
    )
    
    static let mockUsers: [MediStockUser] = [
        mockUser,
        MediStockUser(
            idAuth: "user_2",
            displayName: "Bob Smith",
            email: "bob.smith@example.com",
        ),
        MediStockUser(
            idAuth: "user_3",
            displayName: "Charlie Lee",
            email: "charlie.lee@example.com",
        )
    ]
}
