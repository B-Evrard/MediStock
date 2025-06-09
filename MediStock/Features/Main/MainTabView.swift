import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var session: SessionManager
    
    init() {
        configureTabBar()
    }
    
    var body: some View {
        TabView {
            AisleListView(viewModel: AisleListViewModel(session: session))
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("Aisles")
                        .accessibilityHint("Tap for a list of all the aisles")
                }
            MedicineListView(viewModel: MedicineListViewModel(session: session)  )
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                    Text("All Medicines")
                        .accessibilityHint("Tap for a list of all the medicines")
                }
            UserView(viewModel: UserViewModel(session: session))
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                        .accessibilityHint("Tap for profile view")
                }
        }
    }
    
    private func configureTabBar() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(named: "Background")
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor.white
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = UIColor(named: "Background")
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
