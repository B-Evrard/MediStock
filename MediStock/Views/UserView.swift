//
//  UserView.swift
//  MediStock
//
//  Created by Bruno Evrard on 26/05/2025.
//

import SwiftUI

struct UserView: View {
    @StateObject var viewModel: UserViewModel
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            VStack(alignment: .leading) {
                
                headerSection
                userInfoSection
                Spacer()

            }
            .padding()
        }
        
    }
}

extension UserView {
    private var headerSection: some View {
        HStack {
            Text("User Profile")
                .foregroundColor(.white)
                .font(.largeTitle)
                .bold()
            Spacer()
            Button(action: {
                Task {
                    await viewModel.logout()
                }
                
            }) {
                Image(systemName: "person.slash")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .frame(width: 30, height: 30)
            }
        }
    }
    
    private var userInfoSection: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Name")
                    .font(.body)
                    .bold()
                    .foregroundColor(.black)
                Text(viewModel.user?.displayName ?? "")
                    .foregroundColor(.black)
                    .font(.body)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color("BackgroundElement"))
            .cornerRadius(4)
            .padding(.vertical,10)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Name : \(viewModel.user?.displayName ?? "")")
            
            VStack(alignment: .leading) {
                Text("Email")
                    .font(.body)
                    .bold()
                    .foregroundColor(.black)
                Text(viewModel.user?.email ?? "xx")
                    .foregroundColor(.black)
                    .font(.body)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color("BackgroundElement"))
            .cornerRadius(4)
            .padding(.vertical,10)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Email : \(viewModel.user?.email ?? "")")
            
        }
        
    }
}

#Preview {
    let viewModel = UserViewModel(session: FireBaseAuthService())
    UserView(viewModel: viewModel)
}
