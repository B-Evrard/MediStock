import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel:LoginViewModel
    @State private var isSignUp = false
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            VStack {
                Spacer()
                if (!isSignUp) {
                    SignInView(viewModel: viewModel)
                } else {
                    SignUpView(viewModel: viewModel)
                }
                
                
                Button(action: {
                    Task {
                        if (isSignUp) {
                            _ = await viewModel.signUp()
                            return
                        } else {
                            _ = await viewModel.signIn()
                            return
                        }
                    }
                    
                }) {
                    HStack {
                        Spacer()
                        Text(isSignUp ? "Sign up" : "Sign in")
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
                
                
                Button(action: {
                    isSignUp.toggle()
                }) {
                    Text(isSignUp ? "Have an account? Sign in" : "Don't have an account? Sign up")
                        .font(.callout)
                        .foregroundColor(.white)
                        .accessibilityLabel(isSignUp ? "Have an account? Sign in" : "Don't have an account? Sign up")
                        .accessibilityHint(isSignUp ? "Tap to sign in" : "Tap to sign up")
                }
                .padding(.vertical, 10)
               
                Text(viewModel.message)
                    .foregroundColor(.red)
                    .font(.callout)
                    
                Spacer()
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
    let viewModel = LoginViewModel(authService: FireBaseAuthService(userManager: userManager), userManager: userManager)
    LoginView(viewModel: viewModel)
}

