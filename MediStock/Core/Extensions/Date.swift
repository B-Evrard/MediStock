//
//  GlobalExtensions.swift
//  MediStock
//
//  Created by Bruno Evrard on 21/05/2025.
//
import Foundation

extension Date {
    var formattedDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy 'at' HH:mm"
        return dateFormatter.string(from: self)}
}


