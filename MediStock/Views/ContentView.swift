import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userManager: UserManager

    var body: some View {
        Group {
            if userManager.isConnected {
                MainTabView()
            } else {
                LoginView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(UserManager())
    }
}
