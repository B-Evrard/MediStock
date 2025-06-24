//
//  InputField.swift
//  MediStock
//
//  Created by Bruno Evrard on 23/06/2025.
//

import SwiftUI

struct InputFieldString: View {
    @Binding var text: String
    let placeholder: String
    var keyboard: UIKeyboardType = .default
    var autocorrectionDisabled = false
    var isSecure: Bool = false
    var hasPadding: Bool = false
    var hasCornerRadius: Bool = false
    
    var body: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: $text,
                            prompt: Text(placeholder).foregroundColor(.gray))
            } else {
                TextField(placeholder, text: $text,
                          prompt: Text(placeholder).foregroundColor(.gray))
                    .keyboardType(keyboard)
                    .autocapitalization(.none)
                    .autocorrectionDisabled(autocorrectionDisabled)
            }
        }
        .font(.body)
        .foregroundColor(Color("ColorFont"))
        .if(hasPadding) { view in
            view.padding()
        }
        .background(Color("BackgroundElement"))
        .if(hasCornerRadius) { view in
            view.cornerRadius(20)
        }
       
    }
}
