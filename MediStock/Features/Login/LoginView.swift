import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel:LoginViewModel
    @State private var isSignUp = false
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            VStack {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: 200,
                        height: 200
                    )
                    .padding(.top, 50)
                    .padding(.bottom, 40)
                    .accessibilityLabel("Rebonnté Logo")
               
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
            
        }
    }
    
}

#Preview {
    
    let viewModel = LoginViewModel(session: SessionManager())
    LoginView(viewModel: viewModel)
}

