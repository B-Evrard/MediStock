//
//  Enums.swift
//  MediStock
//
//  Created by Bruno Evrard on 31/05/2025.
//

import Foundation

enum HistoryAction: String, CaseIterable {
    case Add
    case Delete
    case Update
    case Unknown
    
    var display: String {
        switch self {
        case .Add: return "Creation"
        case .Delete: return "Delete"
        case .Update: return "Update"
        case .Unknown: return "Unknown"
        }
    }
}

enum SortOption: String, CaseIterable, Identifiable {
    case name
    case stock

    var id: String { self.rawValue }
}

enum Action {
    case load
    case delete
    case update
}


extension HistoryAction {
    static func from(_ rawValue: String) -> Self {
        Self(rawValue: rawValue) ?? .Unknown
    }
}
