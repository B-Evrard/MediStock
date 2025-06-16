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
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            SecureField("Password", text: $viewModel.password)
                .font(.callout)
                .textFieldStyle(RoundedBorderTextFieldStyle())
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
            
            SecureField("Confirm your password", text: $viewModel.confirmedPassword)
                .font(.callout)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Enter your name", text: $viewModel.name)
                .font(.callout)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        
        }
    }
}

#Preview {
    let viewModel = LoginViewModel(session: SessionManager())
    SignUpView(viewModel: viewModel)
}
