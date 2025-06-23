//
//  SignUpView.swift
//  MediStock
//
//  Created by Bruno Evrard on 25/05/2025.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var viewModel: LoginViewModel
    @State private var showInfo = false
    
    var body: some View {
        VStack {
            
            
            InputFieldString(text: $viewModel.email, placeholder: "Email", keyboard: .emailAddress, autocorrectionDisabled: true, hasPadding: true)
            InputFieldString(text: $viewModel.password, placeholder: "Password", isSecure: true, hasPadding: true)
                .overlay(
                    Group {
                        
                        Button(action: {
                            showInfo.toggle()
                        }) {
                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                        }
                        .padding(.trailing, 5)
                        .popover(isPresented: $showInfo, arrowEdge: .bottom) {
                            Text("Password must have :\n-At least one uppercase\n-At least one digit\n-At least one lowercase\n-At least one symbol\n-Min 8 characters total")
                                .padding()
                                .presentationCompactAdaptation(.popover)
                            
                        }
                        
                        
                    }, alignment: .trailing
                )
            
            InputFieldString(text: $viewModel.confirmedPassword, placeholder: "Confirm your password", isSecure: true, hasPadding: true)
            
            InputFieldString(text: $viewModel.name, placeholder: "Enter your name", autocorrectionDisabled: true, hasPadding: true)
        }
    }
}

#Preview {
    let viewModel = LoginViewModel(session: SessionManager())
    SignUpView(viewModel: viewModel)
}
