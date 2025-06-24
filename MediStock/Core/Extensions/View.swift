//
//  ViewExtensions.swift
//  MediStock
//
//  Created by Bruno Evrard on 23/06/2025.
//

import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
