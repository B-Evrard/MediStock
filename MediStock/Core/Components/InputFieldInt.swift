//
//  InputFieldInt.swift
//  MediStock
//
//  Created by Bruno Evrard on 23/06/2025.
//

import SwiftUI

struct InputFieldInt: View {
    @Binding var value: Int
    
    let placeholder: String
    var formatter: NumberFormatter = .defaultInt

    var body: some View {
        TextField(
            "",
            value: $value,
            formatter: formatter,
            prompt: Text(placeholder).foregroundColor(.gray)
        )
        .keyboardType(.numberPad)
        .font(.body)
        .foregroundColor(Color("ColorFont"))
        .padding()
        .background(Color("BackgroundElement"))
        .cornerRadius(20)
    }
}
