import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var session: FireBaseAuthService
    
    var body: some View {
        TabView {
            AisleListScreen()
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("Aisles")
                }

//            AllMedicinesView()
//                .tabItem {
//                    Image(systemName: "square.grid.2x2")
//                    Text("All Medicines")
//                }
            
            UserView(viewModel: UserViewModel(session: session))
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
