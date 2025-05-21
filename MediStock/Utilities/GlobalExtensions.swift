//
//  GlobalExtensions.swift
//  MediStock
//
//  Created by Bruno Evrard on 21/05/2025.
//
import Foundation

// MARK: Date Extension

// MARK: String Extension
extension String {
    
    var removingAccentsUppercased: String {
        let mutableString = NSMutableString(string: self) as CFMutableString
        CFStringTransform(mutableString, nil, kCFStringTransformStripCombiningMarks, false)
        return (mutableString as String).uppercased()
    }
    
}
