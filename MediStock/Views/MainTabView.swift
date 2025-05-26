import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var userManager: UserManager
    
    var body: some View {
        TabView {
            AisleListView()
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("Aisles")
                }

//            AllMedicinesView()
//                .tabItem {
//                    Image(systemName: "square.grid.2x2")
//                    Text("All Medicines")
//                }
            
            UserView(viewModel: UserViewModel(authService: FireBaseAuthService(userManager: userManager), userManager: userManager))
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
