import SwiftUI

struct LoginView: View {

    @StateObject var viewModel:LoginViewModel
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button(action: {
                session.signIn(email: email, password: password)
            }) {
                Text("Login")
            }
            Button(action: {
                session.signUp(email: email, password: password)
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(SessionStore())
    }
}
