//
//  NumberFormatter.swift
//  MediStock
//
//  Created by Bruno Evrard on 23/06/2025.
//

import Foundation

extension NumberFormatter {
    static let defaultInt: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        formatter.locale = .current
        return formatter
    }()
}
