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
    
    var normalizedSortKey: String {
        let pattern = #"(\d+)"#
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(self.startIndex..., in: self)
        
        guard let match = regex.firstMatch(in: self, range: range),
              let numberRange = Range(match.range(at: 1), in: self) else {
            return self
        }
        
        let number = Int(self[numberRange]) ?? 0
        let paddedNumber = String(format: "%05d", number)
        
        let before = self[..<numberRange.lowerBound]
        let after = self[numberRange.upperBound...]
        
        return "\(before)\(paddedNumber)\(after)"
    }
    
}
