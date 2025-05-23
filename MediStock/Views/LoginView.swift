import SwiftUI

struct LoginView: View {

    @StateObject var viewModel:LoginViewModel
    
    var body: some View {
        VStack {
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button(action: {
                viewModel.signIn()
            }) {
                Text("Login")
            }
            Button(action: {
                viewModel.signUp()
            }) {
                Text("Sign Up")
            }
        }
        .padding()
        .onAppear {
            viewModel.initListen()
        }
    }
        
}

#Preview {
    let viewModel = LoginViewModel(userManager: MockUserManager())
    LoginView(viewModel: LoginViewModel(userManager: userManager))
}

