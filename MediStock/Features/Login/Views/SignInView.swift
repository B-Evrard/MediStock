//
//  SignInView.swift
//  MediStock
//
//  Created by Bruno Evrard on 25/05/2025.
//

import SwiftUI

struct SignInView: View {
    
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            InputFieldString(text: $viewModel.email, placeholder: "Email", keyboard: .emailAddress, autocorrectionDisabled: true, hasPadding: true)
                
            InputFieldString(text: $viewModel.password, placeholder: "Password", isSecure: true, hasPadding: true)
                
        }
    }
    
}

#Preview {
    
    let viewModel = LoginViewModel(session: SessionManager())
    SignInView(viewModel: viewModel)
}
