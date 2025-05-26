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
        VStack {
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            SecureField("Password", text: $viewModel.password)
                .font(.callout)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
    
}

#Preview {
    let userManager = UserManager()
    let viewModel = LoginViewModel(authService: FireBaseAuthService(userManager: userManager), userManager: userManager)
    SignInView(viewModel: viewModel)
}
