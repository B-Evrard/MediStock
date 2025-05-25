import SwiftUI

struct LoginView: View {

    @StateObject var viewModel:LoginViewModel
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            VStack {
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                
                Button(action: {
                    viewModel.signIn()
                }) {
                    HStack {
                        Spacer()
                        Text("Sign in")
                            .font(.callout)
                            .foregroundColor(.white)
                            .bold(true)
                        Spacer()
                    }
                    .padding(.vertical, 15)
                    .background(Color("BackgroundRed"))
                    .cornerRadius(4)
                }
                .padding(.vertical, 30)
                
            }
            .padding(.horizontal, 30)
            
            
            .onAppear {
                viewModel.initListen()
            }
        }
    }
        
}

#Preview {
    let userManager = UserManager()
    let viewModel = LoginViewModel(authService: AuthService(userManager: userManager))
    LoginView(viewModel: viewModel)
}

