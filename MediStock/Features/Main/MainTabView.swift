import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var session: SessionManager
    @State private var aislePath = NavigationPath()
    @State private var medicinePath = NavigationPath()
    
    init() {
        configureTabBar()
    }
    
    var body: some View {
        
        TabView {
            
            NavigationStack(path: $aislePath) {
                AisleListView(viewModel: AisleListViewModel(session: session), path: $aislePath)
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case .medicines(let aisle):
                            let vm = MedicineListViewModel(session: session, aisleSelected: aisle)
                            MedicineListView(viewModel: vm, isFromTab: false, path: $aislePath)
                            
                        case .medicineEdit(let med):
                            MedicineView(viewModel: MedicineViewModel(session: session, medicine: med), path: $aislePath)
                            
                        case .medicineCreate(let aisle):
                            MedicineView(viewModel: MedicineViewModel(session: session, medicine: MedicineViewData(aisle: aisle)), path: $aislePath)
                        }
                    }
            }
            .tabItem {
                Image(systemName: "list.dash")
                Text("Aisles")
            }
            
            
//            NavigationStack(path: $medicinePath) {
//                MedicineListView(viewModel: MedicineListViewModel(session: session), isFromTab: true, path: $medicinePath )
//                    .navigationDestination(for: AppRoute.self) { route in
//                        switch route {
//                        case .medicines(_):
//                            EmptyView()
//                        case .medicineEdit(let med):
//                            MedicineView(viewModel: MedicineViewModel(session: session, medicine: med), path: $medicinePath)
//                            
//                        case .medicineCreate:
//                            MedicineView(viewModel: MedicineViewModel(session: session, medicine: MedicineViewData()), path: $medicinePath)
//                        }
//                    }
//            }
//            .tabItem {
//                Image(systemName: "square.grid.2x2")
//                Text("All Medicines")
//                    .accessibilityHint("Tap for a list of all the medicines")
//            }
            
            
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
